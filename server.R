library(shiny)
library(readxl)
library(DT)
library(ggplot2)

function(input, output, session) {
  
  # =========================
  # READ UPLOADED DATA
  # =========================
  data_uploaded <- reactive({
    
    req(input$file)
    
    file_extension <- tolower(
      tools::file_ext(input$file$name)
    )
    
    if (file_extension == "csv") {
      
      read.csv(
        input$file$datapath,
        header = input$header,
        stringsAsFactors = FALSE
      )
      
    } else if (file_extension %in% c("xlsx")) {
      
      as.data.frame(
        read_excel(
          input$file$datapath,
          col_names = input$header
        )
      )
      
    }
  })
  
  
  # =========================
  # MODULE 1
  # =========================
  output$file_name <- renderText({
    
    req(input$file)
    
    paste(
      "File name:",
      input$file$name
    )
  })
  
  
  output$file_format <- renderText({
    
    req(input$file)
    
    paste(
      "File format:",
      toupper(
        tools::file_ext(input$file$name)
      )
    )
  })
  
  
  output$row_count <- renderText({
    
    paste(
      "Number of rows:",
      nrow(data_uploaded())
    )
  })
  
  
  output$column_count <- renderText({
    
    paste(
      "Number of columns:",
      ncol(data_uploaded())
    )
  })
  
  
  output$missing_count <- renderText({
    
    paste(
      "Missing values:",
      sum(is.na(data_uploaded()))
    )
  })
  
  
  output$preview <- renderDT({
    
    datatable(
      data_uploaded(),
      options = list(
        pageLength = 10,
        scrollX = TRUE
      )
    )
    
  })
  
  
  # =========================
  # MODULE 2: VARIABLE SELECTOR
  # =========================
  
  # =========================
  # SELECTED VARIABLE LABEL
  # =========================
  output$selected_variable_text <- renderUI({
    
    req(input$selected_variable)
    
    tags$h4(
      paste(
        "Selected Variable:",
        input$selected_variable
      )
    )
  })
  
  
  # =========================
  # MODULE 2: SUMMARY
  # =========================
  output$summary_table <- renderTable({
    
    data <- data_uploaded()
    
    req(input$selected_variable)
    
    variable <- data[[input$selected_variable]]
    
    
    # QUANTITATIVE SUMMARY
    if (input$data_type == "numeric") {
      
      valid_values <- suppressWarnings(
        as.numeric(variable[!is.na(variable)])
      )
      
      valid_values <- valid_values[!is.na(valid_values)]
      
      validate(
        need(
          length(valid_values) > 0,
          "The selected variable contains no valid numerical values."
        )
      )
      
      result <- data.frame(
        
        Statistic = c(
          "Valid Observations",
          "Missing Values",
          "Mean",
          "Median",
          "Standard Deviation",
          "Variance",
          "Minimum",
          "First Quartile (Q1)",
          "Third Quartile (Q3)",
          "Maximum"
        ),
        
        Value = c(
          length(valid_values),
          sum(is.na(variable)),
          mean(valid_values),
          median(valid_values),
          sd(valid_values),
          var(valid_values),
          min(valid_values),
          quantile(valid_values, 0.25),
          quantile(valid_values, 0.75),
          max(valid_values)
        )
      )
      
      result$Value <- round(
        result$Value,
        2
      )
      
      result
      
      
      # QUALITATIVE SUMMARY
    } else {
      
      clean_variable <- ifelse(
        is.na(variable) |
          trimws(as.character(variable)) == "",
        "(Missing)",
        as.character(variable)
      )
      
      frequency <- sort(
        table(clean_variable),
        decreasing = TRUE
      )
      
      percentage <- prop.table(
        frequency
      ) * 100
      result <- data.frame(
        
        Category = names(frequency),
        
        Frequency = as.vector(
          frequency
        ),
        
        Percentage = paste0(
          round(
            as.vector(percentage),
            2
          ),
          "%"
        )
      )
      
      # Add total row
      result <- rbind(
        result,
        data.frame(
          Category = "Total",
          Frequency = sum(frequency),
          Percentage = "100%"
        )
      )
      
      result
    }
  })
  # =========================
  # MODULE 3: VARIABLE SELECTOR
  # =========================
  
  # =========================
  # MODULE 3: PLOT TYPE
  # =========================
  output$plot_type_selector <- renderUI({
    
    if (input$plot_data_type == "numeric") {
      
      radioButtons(
        inputId = "plot_type",
        label = "Select Plot Type:",
        choices = c(
          "Histogram" = "histogram",
          "Density Curve" = "density"
        ),
        selected = "histogram"
      )
      
    } else {
      
      radioButtons(
        inputId = "plot_type",
        label = "Select Plot Type:",
        choices = c(
          "Bar Chart" = "bar",
          "Pie Chart" = "pie"
        ),
        selected = "bar"
      )
    }
  })
  
  
  # =========================
  # MODULE 3: BIN WIDTH SLIDER
  # =========================
  output$bin_width_slider <- renderUI({
    
    req(input$plot_variable)
    
    if (
      input$plot_data_type == "numeric" &&
      input$plot_type == "histogram"
    ) {
      
      data <- data_uploaded()
      
      variable <- data[[input$plot_variable]]
      variable <- variable[!is.na(variable)]
      
      validate(
        need(
          length(variable) > 1,
          "Not enough valid numerical observations."
        )
      )
      
      data_range <- max(variable) - min(variable)
      
      default_width <- data_range / 10
      
      if (
        is.na(default_width) ||
        default_width <= 0
      ) {
        default_width <- 1
      }
      
      sliderInput(
        inputId = "bin_width",
        label = "Adjust Bin Width:",
        min = max(default_width / 5, 0.01),
        max = max(default_width * 3, 0.1),
        value = default_width,
        step = max(default_width / 10, 0.01)
      )
    }
  })
  
  
  # =========================
  # MODULE 3: DYNAMIC PLOT
  # =========================
  output$dynamic_plot <- renderPlot({
    
    data <- data_uploaded()
    
    req(
      input$plot_variable,
      input$plot_type
    )
    
    variable_name <- input$plot_variable
    
    
    # -------------------------
    # QUANTITATIVE PLOTS
    # -------------------------
    if (input$plot_data_type == "numeric") {
      
      plot_data <- data.frame(
        value = data[[variable_name]]
      )
      
      plot_data <- plot_data[
        !is.na(plot_data$value),
        ,
        drop = FALSE
      ]
      
      validate(
        need(
          nrow(plot_data) > 1,
          "The selected variable does not have enough valid observations."
        )
      )
      
      
      # HISTOGRAM
      if (input$plot_type == "histogram") {
        
        req(input$bin_width)
        
        validate(
          need(
            input$bin_width > 0,
            "Bin width must be greater than zero."
          )
        )
        
        ggplot(
          plot_data,
          aes(x = value)
        ) +
          
          geom_histogram(
            binwidth = input$bin_width,
            fill = "steelblue",
            color = "white"
          ) +
          
          labs(
            title = paste(
              "Histogram of",
              variable_name
            ),
            subtitle = paste(
              "Bin width:",
              round(input$bin_width, 2)
            ),
            x = variable_name,
            y = "Frequency"
          ) +
          
          theme_minimal(
            base_size = 14
          ) +
          
          theme(
            plot.title = element_text(
              face = "bold",
              size = 18
            ),
            plot.subtitle = element_text(
              size = 12
            ),
            axis.title = element_text(
              face = "bold"
            )
          )
        
        
        # DENSITY CURVE
      } else {
        
        validate(
          need(
            length(unique(plot_data$value)) > 1,
            "A density curve requires variation in the selected variable."
          )
        )
        
        ggplot(
          plot_data,
          aes(x = value)
        ) +
          
          geom_density(
            fill = "skyblue",
            color = "steelblue",
            alpha = 0.6,
            linewidth = 1
          ) +
          
          labs(
            title = paste(
              "Density Curve of",
              variable_name
            ),
            x = variable_name,
            y = "Density"
          ) +
          
          theme_minimal(
            base_size = 14
          ) +
          
          theme(
            plot.title = element_text(
              face = "bold",
              size = 18
            ),
            axis.title = element_text(
              face = "bold"
            )
          )
      }
      
      
      # -------------------------
      # QUALITATIVE PLOTS
      # -------------------------
    } else {
      
      clean_variable <- ifelse(
        is.na(data[[variable_name]]) |
          trimws(as.character(data[[variable_name]])) == "",
        "(Missing)",
        as.character(data[[variable_name]])
      )
      
      frequency_data <- as.data.frame(
        table(clean_variable)
      )
      
      names(frequency_data) <- c(
        "Category",
        "Frequency"
      )
      
      frequency_data <- frequency_data[
        order(
          frequency_data$Frequency,
          decreasing = TRUE
        ),
      ]
      
      
      # BAR CHART
      if (input$plot_type == "bar") {
        
        ggplot(
          frequency_data,
          aes(
            x = reorder(
              Category,
              Frequency
            ),
            y = Frequency
          )
        ) +
          
          geom_col(
            fill = "steelblue"
          ) +
          
          coord_flip() +
          
          labs(
            title = paste(
              "Bar Chart of",
              variable_name
            ),
            x = variable_name,
            y = "Frequency"
          ) +
          
          theme_minimal(
            base_size = 14
          ) +
          
          theme(
            plot.title = element_text(
              face = "bold",
              size = 18
            ),
            axis.title = element_text(
              face = "bold"
            )
          )
        
        
        # PIE CHART
      } else {
        
        ggplot(
          frequency_data,
          aes(
            x = "",
            y = Frequency,
            fill = Category
          )
        ) +
          
          geom_col(
            width = 1,
            color = "white"
          ) +
          
          coord_polar(
            theta = "y"
          ) +
          
          labs(
            title = paste(
              "Pie Chart of",
              variable_name
            ),
            fill = variable_name
          ) +
          
          theme_void(
            base_size = 14
          ) +
          
          theme(
            plot.title = element_text(
              face = "bold",
              size = 18,
              hjust = 0.5
            ),
            legend.title = element_text(
              face = "bold"
            )
          )
      }
    }
  })
  # ============================================================
  # MODULE 4: HYPOTHESIS TESTING
  # ============================================================
  
  
  # ============================================================
  # HYPOTHESIS TEST INPUTS
  # ============================================================
  
  
  # ============================================================
  # ONE-SAMPLE: OPTIONAL QUALITATIVE GROUP FILTER
  # ============================================================
  
  # ============================================================
  # TWO-SAMPLE: SELECT TWO QUALITATIVE GROUPS
  # ============================================================
  
  output$group_selection <- renderUI({
    
    req(input$group_variable)
    
    data <- data_uploaded()
    
    variable <- as.character(
      data[[input$group_variable]]
    )
    
    
    # Detect valid groups only
    groups <- unique(
      variable[
        !is.na(variable) &
          trimws(variable) != ""
      ]
    )
    
    
    if (length(groups) < 2) {
      
      return(
        tags$div(
          class = "alert alert-danger",
          "The selected qualitative variable must contain at least two valid groups."
        )
      )
    }
    
    
    tagList(
      
      selectInput(
        inputId = "selected_group1",
        label = "Select Group 1:",
        choices = groups,
        selected = groups[1]
      ),
      
      selectInput(
        inputId = "selected_group2",
        label = "Select Group 2:",
        choices = groups,
        selected = groups[2]
      ),
      
      helpText(
        "A two-sample test compares exactly two groups. Select any two groups from the chosen qualitative variable."
      )
    )
  })
  
  
  # ============================================================
  # TEST GUIDANCE
  # ============================================================
  
  output$test_guidance <- renderUI({
    
    if (input$test_type == "t") {
      
      tags$div(
        class = "alert alert-info",
        
        strong("T-test selected: "),
        
        "Use a T-test when the population standard deviation is unknown and must be estimated from the sample."
      )
      
    } else {
      
      tags$div(
        class = "alert alert-warning",
        
        strong("Z-test selected: "),
        
        "Use a Z-test when the population standard deviation is known."
      )
    }
  })
  
  
  # ============================================================
  # RUN HYPOTHESIS TEST
  # ============================================================
  
  hypothesis_test <- eventReactive(
    input$run_test,
    {
      
      data <- data_uploaded()
      
      req(input$test_variable)
      
      
      # ========================================================
      # ONE-SAMPLE TEST
      # ========================================================
      
      if (input$sample_structure == "one") {
        
        
        # ------------------------------------------------------
        # USE ALL OBSERVATIONS
        # ------------------------------------------------------
        
        if (
          is.null(input$one_sample_filter) ||
          input$one_sample_filter == "all"
        ) {
          
          x <- data[[input$test_variable]]
          
          sample_description <- "All observations"
          
          
          # ------------------------------------------------------
          # FILTER BY ONE QUALITATIVE GROUP
          # ------------------------------------------------------
          
        } else {
          
          req(
            input$one_group_variable,
            input$one_selected_group
          )
          
          
          group_variable <- as.character(
            data[[input$one_group_variable]]
          )
          
          
          selected_rows <-
            !is.na(group_variable) &
            trimws(group_variable) != "" &
            group_variable == input$one_selected_group
          
          
          x <- data[[input$test_variable]][
            selected_rows
          ]
          
          
          sample_description <- paste(
            input$one_group_variable,
            "=",
            input$one_selected_group
          )
        }
        
        
        # Remove missing quantitative values
        
        x <- x[
          !is.na(x)
        ]
        
        
        validate(
          need(
            length(x) >= 2,
            "The selected sample must contain at least two valid quantitative observations."
          )
        )
        
        
        # ======================================================
        # ONE-SAMPLE T-TEST
        # ======================================================
        
        if (input$test_type == "t") {
          
          test <- t.test(
            x,
            mu = input$mu0,
            alternative = input$alternative
          )
          
          
          data.frame(
            
            Test = "One-Sample T-test",
            
            Sample = sample_description,
            
            Valid_N = length(x),
            
            Sample_Mean = round(
              mean(x),
              4
            ),
            
            Reference_Mean = input$mu0,
            
            Statistic = round(
              unname(test$statistic),
              4
            ),
            
            P_Value = round(
              test$p.value,
              6
            )
          )
          
          
          # ======================================================
          # ONE-SAMPLE Z-TEST
          # ======================================================
          
        } else {
          
          validate(
            need(
              input$known_sd > 0,
              "Population standard deviation must be greater than zero."
            )
          )
          
          
          z <- (
            mean(x) - input$mu0
          ) / (
            input$known_sd /
              sqrt(length(x))
          )
          
          
          if (input$alternative == "two.sided") {
            
            p_value <- 2 *
              pnorm(
                -abs(z)
              )
            
          } else if (input$alternative == "less") {
            
            p_value <- pnorm(z)
            
          } else {
            
            p_value <- 1 -
              pnorm(z)
          }
          
          
          data.frame(
            
            Test = "One-Sample Z-test",
            
            Sample = sample_description,
            
            Valid_N = length(x),
            
            Sample_Mean = round(
              mean(x),
              4
            ),
            
            Reference_Mean = input$mu0,
            
            Statistic = round(
              z,
              4
            ),
            
            P_Value = round(
              p_value,
              6
            )
          )
        }
        
        
        # ========================================================
        # TWO-SAMPLE TEST
        # ========================================================
        
      } else {
        
        req(
          input$group_variable,
          input$selected_group1,
          input$selected_group2
        )
        
        
        validate(
          need(
            input$selected_group1 != input$selected_group2,
            "Please select two different groups."
          )
        )
        
        
        group1 <- input$selected_group1
        group2 <- input$selected_group2
        
        
        test_data <- data.frame(
          
          value = data[[input$test_variable]],
          
          group = as.character(
            data[[input$group_variable]]
          )
        )
        
        
        # Keep only the two selected groups
        
        test_data <- test_data[
          test_data$group %in%
            c(group1, group2),
          ,
          drop = FALSE
        ]
        
        
        # Remove missing observations
        
        complete_data <- test_data[
          complete.cases(test_data),
          ,
          drop = FALSE
        ]
        
        
        x1 <- complete_data$value[
          complete_data$group == group1
        ]
        
        x2 <- complete_data$value[
          complete_data$group == group2
        ]
        
        
        validate(
          need(
            length(x1) >= 2 &&
              length(x2) >= 2,
            "Each selected group must contain at least two valid quantitative observations."
          )
        )
        
        
        # ======================================================
        # TWO-SAMPLE T-TEST
        # ======================================================
        
        if (input$test_type == "t") {
          
          test <- t.test(
            x1,
            x2,
            alternative = input$alternative
          )
          
          
          data.frame(
            
            Test = "Two-Sample T-test",
            
            Group_1 = group1,
            
            Valid_N_1 = length(x1),
            
            Mean_1 = round(
              mean(x1),
              4
            ),
            
            Group_2 = group2,
            
            Valid_N_2 = length(x2),
            
            Mean_2 = round(
              mean(x2),
              4
            ),
            
            Statistic = round(
              unname(test$statistic),
              4
            ),
            
            P_Value = round(
              test$p.value,
              6
            )
          )
          
          
          # ======================================================
          # TWO-SAMPLE Z-TEST
          # ======================================================
          
        } else {
          
          validate(
            need(
              input$known_sd1 > 0 &&
                input$known_sd2 > 0,
              "Both population standard deviations must be greater than zero."
            )
          )
          
          
          z <- (
            mean(x1) - mean(x2)
          ) /
            sqrt(
              input$known_sd1^2 /
                length(x1) +
                input$known_sd2^2 /
                length(x2)
            )
          
          
          if (input$alternative == "two.sided") {
            
            p_value <- 2 *
              pnorm(
                -abs(z)
              )
            
          } else if (input$alternative == "less") {
            
            p_value <- pnorm(z)
            
          } else {
            
            p_value <- 1 -
              pnorm(z)
          }
          
          
          data.frame(
            
            Test = "Two-Sample Z-test",
            
            Group_1 = group1,
            
            Valid_N_1 = length(x1),
            
            Mean_1 = round(
              mean(x1),
              4
            ),
            
            Group_2 = group2,
            
            Valid_N_2 = length(x2),
            
            Mean_2 = round(
              mean(x2),
              4
            ),
            
            Statistic = round(
              z,
              4
            ),
            
            P_Value = round(
              p_value,
              6
            )
          )
        }
      }
    }
  )
  
  
  # ============================================================
  # DISPLAY HYPOTHESIS TEST RESULT
  # ============================================================
  
  output$hypothesis_result <- renderTable({
    
    result <- hypothesis_test()
    req(result)
    
    result$P_Value <- ifelse(
      result$P_Value < 0.001,
      "< 0.001",
      format(result$P_Value, digits = 3, nsmall = 3)
    )
    
    result
    
  })
  
  
  # ============================================================
  # HYPOTHESIS TEST CONCLUSION
  # ============================================================
  
  output$hypothesis_conclusion <- renderUI({
    
    result <- hypothesis_test()
    
    req(result)
    
    p_value <- result$P_Value[1]
    
    alpha <- 0.05
    
    
    if (p_value < alpha) {
      
      p_text <- if (p_value < 0.001) {
        "less than 0.001"
      } else {
        format(p_value, digits = 3, nsmall = 3)
      }
      
      tags$div(
        class = "alert alert-success",
        
        strong("Decision: Reject H₀. "),
        
        paste(
          "The p-value is",
          p_text,
          "which is less than 0.05. There is statistically significant evidence against the null hypothesis."
        )
      )
      
    } else {
      
      p_text <- format(
        p_value,
        digits = 3,
        nsmall = 3
      )
      
      tags$div(
        class = "alert alert-secondary",
        
        strong("Decision: Fail to Reject H₀. "),
        
        paste(
          "The p-value is",
          p_text,
          "which is greater than or equal to 0.05. There is insufficient evidence to reject the null hypothesis."
        )
      )
    }
  })
  
  # ============================================================
  # MODULE 5: RELATIONSHIP MODELING & REGRESSION
  # ============================================================
  
  
  # ============================================================
  # X VARIABLE SELECTOR
  # ============================================================
  
  output$x_variable_selector <- renderUI({
    
    data <- data_uploaded()
    
    numeric_variables <- names(data)[
      sapply(data, is.numeric)
    ]
    
    
    if (length(numeric_variables) < 2) {
      
      return(
        tags$div(
          class = "alert alert-warning",
          "At least two quantitative variables are required for relationship analysis."
        )
      )
    }
    
    
    selectInput(
      inputId = "x_variable",
      label = "Select X Variable:",
      choices = numeric_variables,
      selected = numeric_variables[1]
    )
  })
  
  
  # ============================================================
  # Y VARIABLE SELECTOR
  # ============================================================
  
  output$y_variable_selector <- renderUI({
    
    data <- data_uploaded()
    
    numeric_variables <- names(data)[
      sapply(data, is.numeric)
    ]
    
    
    if (length(numeric_variables) < 2) {
      return(NULL)
    }
    
    
    selectInput(
      inputId = "y_variable",
      label = "Select Y Variable:",
      choices = numeric_variables,
      selected = numeric_variables[2]
    )
  })
  
  
  # ============================================================
  # MATRIX VARIABLE SELECTOR
  # ============================================================
  
  output$matrix_variable_selector <- renderUI({
    
    data <- data_uploaded()
    
    numeric_variables <- names(data)[
      sapply(data, is.numeric)
    ]
    
    req(input$matrix_variable_count)
    
    
    if (length(numeric_variables) < 2) {
      
      return(
        tags$div(
          class = "alert alert-warning",
          "At least two quantitative variables are required to create a correlation matrix."
        )
      )
    }
    
    
    requested_count <- input$matrix_variable_count
    
    
    if (requested_count > length(numeric_variables)) {
      
      return(
        tags$div(
          class = "alert alert-warning",
          
          paste(
            "Only",
            length(numeric_variables),
            "quantitative variables are available in this dataset."
          )
        )
      )
    }
    
    
    default_variables <- numeric_variables[
      seq_len(requested_count)
    ]
    
    
    selectInput(
      inputId = "matrix_variables",
      
      label = paste(
        "Select",
        requested_count,
        "Quantitative Variables:"
      ),
      
      choices = numeric_variables,
      
      selected = default_variables,
      
      multiple = TRUE
    )
  })
  
  
  # ============================================================
  # PAIRWISE COMPLETE DATA
  # ============================================================
  
  relationship_data <- reactive({
    
    req(
      input$x_variable,
      input$y_variable
    )
    
    data <- data_uploaded()
    
    
    validate(
      need(
        input$x_variable != input$y_variable,
        "Please select two different quantitative variables."
      )
    )
    
    
    temp_data <- data.frame(
      X = data[[input$x_variable]],
      Y = data[[input$y_variable]]
    )
    
    
    temp_data <- temp_data[
      complete.cases(temp_data),
      ,
      drop = FALSE
    ]
    
    
    validate(
      need(
        nrow(temp_data) >= 3,
        "At least three complete observations are required for correlation and regression analysis."
      )
    )
    
    
    validate(
      need(
        sd(temp_data$X) > 0,
        "The selected X variable has no variation."
      )
    )
    
    
    validate(
      need(
        sd(temp_data$Y) > 0,
        "The selected Y variable has no variation."
      )
    )
    
    
    temp_data
  })
  
  
  # ============================================================
  # CORRELATION TEST
  # ============================================================
  
  correlation_test <- reactive({
    
    data <- relationship_data()
    
    req(input$correlation_method)
    
    
    if (input$correlation_method == "pearson") {
      
      cor.test(
        data$X,
        data$Y,
        method = "pearson"
      )
      
    } else {
      
      cor.test(
        data$X,
        data$Y,
        method = "spearman",
        exact = FALSE
      )
    }
  })
  
  
  # ============================================================
  # CORRELATION DESCRIPTION
  # ============================================================
  
  output$correlation_description <- renderUI({
    
    req(
      input$x_variable,
      input$y_variable,
      input$correlation_method
    )
    
    
    method_name <- if (
      input$correlation_method == "pearson"
    ) {
      "Pearson"
    } else {
      "Spearman"
    }
    
    
    tags$div(
      class = "alert alert-info",
      
      strong(
        paste0(
          method_name,
          " correlation selected. "
        )
      ),
      
      paste(
        "The analysis examines the relationship between",
        input$x_variable,
        "and",
        input$y_variable,
        "."
      )
    )
  })
  
  
  # ============================================================
  # CORRELATION RESULT
  # ============================================================
  
  output$correlation_result <- renderTable({
    
    data <- relationship_data()
    
    test <- correlation_test()
    
    
    coefficient <- unname(
      test$estimate
    )
    
    
    result <- data.frame(
      
      Method = if (
        input$correlation_method == "pearson"
      ) {
        "Pearson"
      } else {
        "Spearman"
      },
      
      Variable_X = input$x_variable,
      
      Variable_Y = input$y_variable,
      
      Valid_Observations = nrow(data),
      
      Coefficient = round(
        coefficient,
        4
      ),
      
      P_Value = if (
        test$p.value < 0.001
      ) {
        "< 0.001"
      } else {
        format(
          test$p.value,
          digits = 3,
          nsmall = 3
        )
      },
      
      stringsAsFactors = FALSE
    )
    
    
    result
  })
  
  
  # ============================================================
  # CORRELATION CONCLUSION
  # ============================================================
  
  output$correlation_conclusion <- renderUI({
    
    test <- correlation_test()
    
    coefficient <- unname(
      test$estimate
    )
    
    p_value <- test$p.value
    p_text <- if (p_value < 0.001) {
      "< 0.001"
    } else {
      format(
        p_value,
        digits = 3,
        nsmall = 3
      )
    }
    
    
    direction <- if (coefficient > 0) {
      
      "positive"
      
    } else if (coefficient < 0) {
      
      "negative"
      
    } else {
      
      "no"
    }
    
    
    absolute_coefficient <- abs(
      coefficient
    )
    
    
    strength <- if (
      absolute_coefficient < 0.20
    ) {
      
      "very weak"
      
    } else if (
      absolute_coefficient < 0.40
    ) {
      
      "weak"
      
    } else if (
      absolute_coefficient < 0.60
    ) {
      
      "moderate"
      
    } else if (
      absolute_coefficient < 0.80
    ) {
      
      "strong"
      
    } else {
      
      "very strong"
    }
    
    
    if (p_value < 0.05) {
      
      tags$div(
        class = "alert alert-success",
        
        strong("Correlation Result: "),
        
        paste(
          "There is a statistically significant",
          strength,
          direction,
          "relationship between",
          input$x_variable,
          "and",
          input$y_variable,
          paste0(
            "(p-value ",
            if (p_value < 0.001) "< " else "= ",
            if (p_value < 0.001) "0.001" else p_text,
            ")."
          )
        )
      )
      
    } else {
      
      tags$div(
        class = "alert alert-secondary",
        
        strong("Correlation Result: "),
        
        paste(
          "The",
          strength,
          direction,
          "relationship between",
          input$x_variable,
          "and",
          input$y_variable,
          "is not statistically significant",
          paste0(
            "(p-value = ",
            round(p_value, 6),
            ")."
          )
        )
      )
    }
  })
  
  
  # ============================================================
  # SCATTERPLOT
  # ============================================================
  
  output$scatter_plot <- renderPlot({
    
    data <- relationship_data()
    
    
    plot(
      data$X,
      data$Y,
      
      main = paste(
        input$y_variable,
        "vs",
        input$x_variable
      ),
      
      xlab = input$x_variable,
      
      ylab = input$y_variable,
      
      pch = 19
    )
    
    
    model <- lm(
      Y ~ X,
      data = data
    )
    
    
    abline(
      model,
      lwd = 2
    )
  })
  
  
  # ============================================================
  # LINEAR REGRESSION MODEL
  # ============================================================
  
  regression_model <- reactive({
    
    data <- relationship_data()
    
    lm(
      Y ~ X,
      data = data
    )
  })
  
  
  # ============================================================
  # REGRESSION COEFFICIENTS
  # ============================================================
  
  output$regression_coefficients <- renderTable({
    
    model <- regression_model()
    
    model_summary <- summary(
      model
    )
    
    
    coefficient_table <- as.data.frame(
      model_summary$coefficients
    )
    
    
    coefficient_table$Term <- c(
      "Intercept",
      input$x_variable
    )
    
    
    coefficient_table <- coefficient_table[
      ,
      c(
        "Term",
        "Estimate",
        "Std. Error",
        "t value",
        "Pr(>|t|)"
      )
    ]
    
    
    names(coefficient_table) <- c(
      "Term",
      "Estimate",
      "Standard_Error",
      "T_Value",
      "P_Value"
    )
    
    
    coefficient_table$Estimate <- round(
      coefficient_table$Estimate,
      4
    )
    
    coefficient_table$Standard_Error <- round(
      coefficient_table$Standard_Error,
      4
    )
    
    coefficient_table$T_Value <- round(
      coefficient_table$T_Value,
      4
    )
    
    coefficient_table$P_Value <- round(
      coefficient_table$P_Value,
      6
    )
    
    
    rownames(
      coefficient_table
    ) <- NULL
    
    
    coefficient_table
  })
  
  
  # ============================================================
  # FORMATTED REGRESSION EQUATION
  # ============================================================
  
  output$regression_equation <- renderUI({
    
    model <- regression_model()
    
    coefficients <- coef(
      model
    )
    
    
    intercept <- round(
      coefficients[1],
      4
    )
    
    slope <- round(
      coefficients[2],
      4
    )
    
    
    if (slope >= 0) {
      
      equation <- paste0(
        input$y_variable,
        " = ",
        intercept,
        " + ",
        slope,
        " × ",
        input$x_variable
      )
      
    } else {
      
      equation <- paste0(
        input$y_variable,
        " = ",
        intercept,
        " - ",
        abs(slope),
        " × ",
        input$x_variable
      )
    }
    
    
    tags$div(
      class = "alert alert-info",
      
      strong("Regression Equation: "),
      
      equation
    )
  })
  
  
  # ============================================================
  # REGRESSION STATISTICS
  # ============================================================
  
  output$regression_statistics <- renderUI({
    
    model <- regression_model()
    
    model_summary <- summary(
      model
    )
    
    
    r_squared <- model_summary$r.squared
    
    adjusted_r_squared <-
      model_summary$adj.r.squared
    
    
    f_statistic <- model_summary$fstatistic
    
    
    model_p_value <- pf(
      f_statistic[1],
      f_statistic[2],
      f_statistic[3],
      lower.tail = FALSE
    )
    
    
    tags$div(
      class = "alert alert-info",
      
      strong("Model Fit"),
      
      tags$br(),
      tags$br(),
      
      paste(
        "R-squared:",
        round(
          r_squared,
          4
        )
      ),
      
      tags$br(),
      
      paste(
        "Adjusted R-squared:",
        round(
          adjusted_r_squared,
          4
        )
      ),
      
      tags$br(),
      
      paste(
        "Model p-value:",
        round(
          model_p_value,
          6
        )
      ),
      
      tags$br(),
      tags$br(),
      
      
      if (model_p_value < 0.05) {
        
        tags$span(
          "The linear regression model is statistically significant at the 0.05 significance level."
        )
        
      } else {
        
        tags$span(
          "The linear regression model is not statistically significant at the 0.05 significance level."
        )
      }
    )
  })
  
  
  # ============================================================
  # RESIDUALS VS FITTED PLOT
  # ============================================================
  
  output$residual_plot <- renderPlot({
    
    model <- regression_model()
    
    
    fitted_values <- fitted(
      model
    )
    
    residual_values <- residuals(
      model
    )
    
    
    plot(
      fitted_values,
      residual_values,
      
      main = "Residuals vs Fitted Values",
      
      xlab = "Fitted Values",
      
      ylab = "Residuals",
      
      pch = 19
    )
    
    
    abline(
      h = 0,
      lty = 2
    )
  })
  
  
  # ============================================================
  # NORMAL Q-Q PLOT
  # ============================================================
  
  output$qq_plot <- renderPlot({
    
    model <- regression_model()
    
    residual_values <- residuals(
      model
    )
    
    
    qqnorm(
      residual_values,
      
      main = "Normal Q-Q Plot of Residuals",
      
      pch = 19
    )
    
    
    qqline(
      residual_values,
      lwd = 2
    )
  })
  
  
  # ============================================================
  # CORRELATION MATRIX
  # ============================================================
  
  output$correlation_matrix <- renderTable({
    
    req(
      input$matrix_variables,
      input$matrix_variable_count,
      input$matrix_method
    )
    
    
    validate(
      need(
        length(input$matrix_variables) ==
          input$matrix_variable_count,
        
        paste(
          "Please select exactly",
          input$matrix_variable_count,
          "quantitative variables."
        )
      )
    )
    
    
    data <- data_uploaded()
    
    
    matrix_data <- data[
      ,
      input$matrix_variables,
      drop = FALSE
    ]
    
    
    correlation_matrix <- cor(
      matrix_data,
      use = "pairwise.complete.obs",
      method = input$matrix_method
    )
    
    
    round(
      correlation_matrix,
      4
    )
    
  },
  rownames = TRUE)
  
  
  # ============================================================
  # SCATTERPLOT MATRIX
  # ============================================================
  
  output$scatter_matrix <- renderPlot({
    
    req(
      input$matrix_variables,
      input$matrix_variable_count,
      input$matrix_method
    )
    
    
    validate(
      need(
        length(input$matrix_variables) ==
          input$matrix_variable_count,
        
        paste(
          "Please select exactly",
          input$matrix_variable_count,
          "quantitative variables."
        )
      )
    )
    
    
    data <- data_uploaded()
    
    
    matrix_data <- data[
      ,
      input$matrix_variables,
      drop = FALSE
    ]
    
    
    matrix_data <- matrix_data[
      complete.cases(matrix_data),
      ,
      drop = FALSE
    ]
    
    
    validate(
      need(
        nrow(matrix_data) >= 3,
        "At least three complete observations are required to create the scatterplot matrix."
      )
    )
    
    
    pairs(
      matrix_data,
      
      main = paste(
        if (
          input$matrix_method == "pearson"
        ) {
          "Pearson"
        } else {
          "Spearman"
        },
        "Relationship Matrix"
      ),
      
      pch = 19
    )
  })
  # ============================================================
  # MODULE 6: USER GUIDE
  # ============================================================
  
  output$correlation_guide_table <- renderTable({
    
    data.frame(
      
      "Absolute Correlation" = c(
        "0.00 - 0.19",
        "0.20 - 0.39",
        "0.40 - 0.59",
        "0.60 - 0.79",
        "0.80 - 1.00"
      ),
      
      Interpretation = c(
        "Very Weak",
        "Weak",
        "Moderate",
        "Strong",
        "Very Strong"
      ),
      
      stringsAsFactors = FALSE,
      check.names = FALSE
    )
    
  },
  striped = TRUE,
  bordered = TRUE,
  hover = TRUE,
  width = "60%"
  )
  # ============================================================
  # FINAL CORRECTION: VARIABLE SELECTION
  # Based on lecturer feedback
  # ============================================================
  
  # ------------------------------------------------------------
  # Suitable continuous quantitative variables
  # ------------------------------------------------------------
  continuous_variables_final <- reactive({
    
    data <- data_uploaded()
    req(data)
    
    # Start with numeric variables
    vars <- names(data)[sapply(data, is.numeric)]
    
    
    # ----------------------------------------------------------
    # Remove identifier variables
    # Example: id, student_id, participant_id
    # ----------------------------------------------------------
    id_vars <- vars[
      grepl(
        "(^id$|_id$|^id_|^identifier$)",
        vars,
        ignore.case = TRUE
      )
    ]
    
    
    # ----------------------------------------------------------
    # Detect numeric-coded categorical variables
    # Example: 0/1, 0/1/2, or coded levels such as 1-5
    #
    # A variable is treated as coded categorical when:
    # 1. It has 5 or fewer unique non-missing values, AND
    # 2. All values are whole numbers
    # ----------------------------------------------------------
    coded_categorical_vars <- vars[
      sapply(
        data[vars],
        function(x) {
          
          x <- x[!is.na(x)]
          
          if (length(x) == 0) {
            return(FALSE)
          }
          
          unique_values <- unique(x)
          
          length(unique_values) <= 5 &&
            all(
              abs(
                unique_values - round(unique_values)
              ) < 1e-8
            )
        }
      )
    ]
    
    
    # Remove IDs and coded categorical variables
    vars <- setdiff(
      vars,
      union(
        id_vars,
        coded_categorical_vars
      )
    )
    
    
    vars
  })
  
  # ------------------------------------------------------------
  # Suitable qualitative / categorical variables
  # ------------------------------------------------------------
  qualitative_variables_final <- reactive({
    
    data <- data_uploaded()
    req(data)
    
    # ----------------------------------------------------------
    # Character and factor variables
    # ----------------------------------------------------------
    categorical_vars <- names(data)[
      sapply(
        data,
        function(x) {
          is.character(x) || is.factor(x)
        }
      )
    ]
    
    
    # ----------------------------------------------------------
    # Numeric-coded categorical variables
    # Example: 0/1, 0/1/2, 1-5 coded levels
    # ----------------------------------------------------------
    numeric_vars <- names(data)[sapply(data, is.numeric)]
    
    coded_categorical_vars <- numeric_vars[
      sapply(
        data[numeric_vars],
        function(x) {
          
          x <- x[!is.na(x)]
          
          if (length(x) == 0) {
            return(FALSE)
          }
          
          unique_values <- unique(x)
          
          length(unique_values) <= 5 &&
            all(
              abs(
                unique_values - round(unique_values)
              ) < 1e-8
            )
        }
      )
    ]
    
    
    # ----------------------------------------------------------
    # Remove identifier variables
    # ----------------------------------------------------------
    id_vars <- names(data)[
      grepl(
        "(^id$|_id$|^id_|^identifier$)",
        names(data),
        ignore.case = TRUE
      )
    ]
    
    
    # Combine qualitative variables
    qualitative_vars <- union(
      categorical_vars,
      coded_categorical_vars
    )
    
    qualitative_vars <- setdiff(
      qualitative_vars,
      id_vars
    )
    
    
    qualitative_vars
  })
  
  
  # ============================================================
  # MODULE 5 CORRECTION
  # PAIRWISE ANALYSIS
  # ============================================================
  
  # X Variable
  output$x_variable_selector <- renderUI({
    
    data <- data_uploaded()
    req(data)
    
    vars <- continuous_variables_final()
    
    validate(
      need(
        length(vars) >= 1,
        "No suitable continuous quantitative variables were found."
      )
    )
    
    selectInput(
      "x_variable",
      "Select X Variable:",
      choices = vars,
      selected = vars[1]
    )
  })
  
  
  # Y Variable
  output$y_variable_selector <- renderUI({
    
    data <- data_uploaded()
    req(data)
    
    vars <- continuous_variables_final()
    
    validate(
      need(
        length(vars) >= 2,
        "At least two continuous quantitative variables are required."
      )
    )
    
    selectInput(
      "y_variable",
      "Select Y Variable:",
      choices = vars,
      selected = vars[2]
    )
  })
  
  
  # ============================================================
  # MODULE 5 CORRECTION
  # CORRELATION MATRIX
  # ============================================================
  
  output$matrix_variable_selector <- renderUI({
    
    data <- data_uploaded()
    req(data)
    
    vars <- continuous_variables_final()
    
    validate(
      need(
        length(vars) >= 2,
        "At least two continuous quantitative variables are required."
      )
    )
    
    n_requested <- input$matrix_variable_count
    
    if (is.null(n_requested)) {
      n_requested <- 3
    }
    
    n_select <- min(
      n_requested,
      length(vars)
    )
    
    selectInput(
      "matrix_variables",
      "Select Quantitative Variables:",
      choices = vars,
      selected = head(vars, n_select),
      multiple = TRUE
    )
  })
  # ============================================================
  # FINAL CORRECTION: MODULE 4 VARIABLE SELECTION
  # Based on lecturer feedback
  # ============================================================
  
  
  # ============================================================
  # MODULE 4: HYPOTHESIS TEST INPUTS - CORRECTED
  # ============================================================
  
  output$hypothesis_inputs <- renderUI({
    
    data <- data_uploaded()
    req(data)
    
    # Use corrected variable classification
    numeric_variables <- continuous_variables_final()
    categorical_variables <- qualitative_variables_final()
    
    
    # Make sure quantitative variables are available
    if (length(numeric_variables) == 0) {
      
      return(
        tags$div(
          class = "alert alert-warning",
          "No suitable continuous quantitative variables were detected."
        )
      )
    }
    
    
    # ==========================================================
    # ONE-SAMPLE TEST
    # ==========================================================
    
    if (input$sample_structure == "one") {
      
      tagList(
        
        selectInput(
          inputId = "test_variable",
          label = "Select Quantitative Variable:",
          choices = numeric_variables,
          selected = numeric_variables[1]
        ),
        
        radioButtons(
          inputId = "one_sample_filter",
          label = "Select Sample:",
          choices = c(
            "Use All Observations" = "all",
            "Filter by One Qualitative Group" = "group"
          ),
          selected = "all"
        ),
        
        uiOutput("one_sample_group_inputs"),
        
        numericInput(
          inputId = "mu0",
          label = "Hypothesised Mean (μ₀):",
          value = 0
        ),
        
        conditionalPanel(
          condition = "input.test_type == 'z'",
          
          numericInput(
            inputId = "known_sd",
            label = "Known Population Standard Deviation (σ):",
            value = 1,
            min = 0.0001
          )
        )
      )
      
      
      # ==========================================================
      # TWO-SAMPLE TEST
      # ==========================================================
      
    } else {
      
      # Make sure qualitative variables are available
      if (length(categorical_variables) == 0) {
        
        return(
          tags$div(
            class = "alert alert-warning",
            "No suitable qualitative variables were detected."
          )
        )
      }
      
      
      tagList(
        
        selectInput(
          inputId = "test_variable",
          label = "Select Quantitative Variable:",
          choices = numeric_variables,
          selected = numeric_variables[1]
        ),
        
        selectInput(
          inputId = "group_variable",
          label = "Select Qualitative Variable:",
          choices = categorical_variables,
          selected = categorical_variables[1]
        ),
        
        uiOutput("group_selection"),
        
        conditionalPanel(
          condition = "input.test_type == 'z'",
          
          numericInput(
            inputId = "known_sd1",
            label = "Known SD for Group 1:",
            value = 1,
            min = 0.0001
          ),
          
          numericInput(
            inputId = "known_sd2",
            label = "Known SD for Group 2:",
            value = 1,
            min = 0.0001
          )
        )
      )
    }
  })
  
  
  # ============================================================
  # MODULE 4: ONE-SAMPLE QUALITATIVE FILTER - CORRECTED
  # ============================================================
  
  output$one_sample_group_inputs <- renderUI({
    
    req(input$one_sample_filter)
    
    # Nothing needs to be displayed when using all observations
    if (input$one_sample_filter == "all") {
      return(NULL)
    }
    
    data <- data_uploaded()
    req(data)
    
    categorical_variables <- qualitative_variables_final()
    
    
    if (length(categorical_variables) == 0) {
      
      return(
        tags$div(
          class = "alert alert-warning",
          "No suitable qualitative variables were detected in the dataset."
        )
      )
    }
    
    
    # Keep currently selected variable if it is still valid
    selected_variable <- input$one_group_variable
    
    if (
      is.null(selected_variable) ||
      !(selected_variable %in% categorical_variables)
    ) {
      
      selected_variable <- categorical_variables[1]
    }
    
    
    variable <- as.character(
      data[[selected_variable]]
    )
    
    
    # Detect valid groups only
    groups <- unique(
      variable[
        !is.na(variable) &
          trimws(variable) != ""
      ]
    )
    
    
    tagList(
      
      selectInput(
        inputId = "one_group_variable",
        label = "Select Qualitative Variable:",
        choices = categorical_variables,
        selected = selected_variable
      ),
      
      selectInput(
        inputId = "one_selected_group",
        label = "Select Group:",
        choices = groups,
        selected = if (length(groups) > 0) groups[1] else NULL
      )
    )
  })
  
  
  # ============================================================
  # MODULE 4: TWO-SAMPLE GROUP SELECTION - CORRECTED
  # ============================================================
  
  output$group_selection <- renderUI({
    
    req(input$group_variable)
    
    data <- data_uploaded()
    req(data)
    
    # Make sure selected variable belongs to corrected
    # qualitative variable list
    categorical_variables <- qualitative_variables_final()
    
    validate(
      need(
        input$group_variable %in% categorical_variables,
        "Please select a suitable qualitative grouping variable."
      )
    )
    
    
    variable <- as.character(
      data[[input$group_variable]]
    )
    
    
    # Remove missing and blank groups
    groups <- unique(
      variable[
        !is.na(variable) &
          trimws(variable) != ""
      ]
    )
    
    
    validate(
      need(
        length(groups) >= 2,
        "The selected qualitative variable must contain at least two valid groups."
      )
    )
    
    
    tagList(
      
      selectInput(
        inputId = "selected_group1",
        label = "Select Group 1:",
        choices = groups,
        selected = groups[1]
      ),
      
      selectInput(
        inputId = "selected_group2",
        label = "Select Group 2:",
        choices = groups,
        selected = groups[2]
      ),
      
      helpText(
        "A two-sample test compares one quantitative variable between exactly two groups from a qualitative variable."
      )
    )
  })
  # ============================================================
  # FINAL CORRECTION: MODULE 2 & MODULE 3 VARIABLE SELECTION
  # Based on lecturer feedback
  # ============================================================
  
  
  # ============================================================
  # MODULE 2: DESCRIPTIVE STATISTICS - CORRECTED
  # ============================================================
  
  output$variable_selector <- renderUI({
    
    data <- data_uploaded()
    req(data)
    
    if (input$data_type == "numeric") {
      
      # Only suitable continuous quantitative variables
      numeric_variables <- continuous_variables_final()
      
      if (length(numeric_variables) == 0) {
        
        return(
          p("No suitable continuous quantitative variables were detected.")
        )
      }
      
      selectInput(
        inputId = "selected_variable",
        label = "Select Quantitative Variable:",
        choices = numeric_variables,
        selected = numeric_variables[1]
      )
      
    } else {
      
      # Suitable qualitative / categorical variables
      categorical_variables <- qualitative_variables_final()
      
      if (length(categorical_variables) == 0) {
        
        return(
          p("No suitable qualitative variables were detected.")
        )
      }
      
      selectInput(
        inputId = "selected_variable",
        label = "Select Qualitative Variable:",
        choices = categorical_variables,
        selected = categorical_variables[1]
      )
    }
  })
  
  
  # ============================================================
  # MODULE 3: DATA VISUALIZATION - CORRECTED
  # ============================================================
  
  output$plot_variable_selector <- renderUI({
    
    data <- data_uploaded()
    req(data)
    
    if (input$plot_data_type == "numeric") {
      
      # Histogram and density curve:
      # use suitable continuous quantitative variables
      numeric_variables <- continuous_variables_final()
      
      if (length(numeric_variables) == 0) {
        
        return(
          p("No suitable continuous quantitative variables were detected.")
        )
      }
      
      selectInput(
        inputId = "plot_variable",
        label = "Select Quantitative Variable:",
        choices = numeric_variables,
        selected = numeric_variables[1]
      )
      
    } else {
      
      # Bar chart and pie chart:
      # use suitable qualitative variables
      categorical_variables <- qualitative_variables_final()
      
      if (length(categorical_variables) == 0) {
        
        return(
          p("No suitable qualitative variables were detected.")
        )
      }
      
      selectInput(
        inputId = "plot_variable",
        label = "Select Qualitative Variable:",
        choices = categorical_variables,
        selected = categorical_variables[1]
      )
    }
  })
}