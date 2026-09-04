library(shiny)
library(DT)

navbarPage(
  
  title = div(
    style = "font-weight: 700;",
    "📊 StatInsight"
  ),
  
  header = tags$head(
    
    tags$style(HTML("

      body {
        background: linear-gradient(
          135deg,
          #f8fbff 0%,
          #f4f7ff 45%,
          #faf7ff 100%
        );

        font-family: 'Segoe UI', Arial, sans-serif;
        color: #263238;
      }

      .navbar {
        background: linear-gradient(
          90deg,
          #263859,
          #435b8c,
          #6c63a8
        ) !important;

        border: none !important;
        box-shadow: 0 4px 18px rgba(0,0,0,0.12);

        padding-top: 5px;
        padding-bottom: 5px;
      }

      .navbar-default .navbar-brand {
        color: white !important;
        font-size: 20px;
        font-weight: 700;
      }

      .navbar-default .navbar-nav > li > a {
        color: rgba(255,255,255,0.88) !important;
        font-weight: 500;
      }

      .navbar-default .navbar-nav > li > a:hover {
        color: white !important;
        background: rgba(255,255,255,0.10) !important;
      }

      .navbar-default .navbar-nav > .active > a,
      .navbar-default .navbar-nav > .active > a:hover {
        color: white !important;
        background: rgba(255,255,255,0.16) !important;
        border-radius: 8px;
      }

      .well {
        background: white !important;
        border: none !important;
        border-radius: 16px !important;
        padding: 22px !important;
        box-shadow: 0 5px 20px rgba(34,51,84,0.08) !important;
      }

      h2, h3 {
        color: #30456b;
        font-weight: 700;
      }

      h4 {
        color: #435b8c;
        font-weight: 650;
      }

      .btn-primary {
        background: linear-gradient(
          90deg,
          #435b8c,
          #6c63a8
        ) !important;

        border: none !important;
        border-radius: 9px !important;
      }

      .form-control {
        border-radius: 8px !important;
        border: 1px solid #dfe4ef !important;
        box-shadow: none !important;
      }

    "))
  ),
  # =========================
  # HOME PAGE
  # =========================
  
  tabPanel(
    "🏠 Home",
    
    fluidPage(
      
      div(
        style = "
        background: linear-gradient(
          120deg,
          #263859,
          #526fa4,
          #7469b6
        );
        color: white;
        padding: 45px 35px;
        border-radius: 0 0 24px 24px;
        margin-bottom: 28px;
        text-align: center;
        box-shadow: 0 10px 30px rgba(38,56,89,0.18);
      ",
        
        h1(
          style = "font-weight: 750; font-size: 38px;",
          "📊 Interactive Statistical Analysis Dashboard"
        ),
        
        p(
          style = "
          font-size: 16px;
          opacity: 0.92;
          max-width: 800px;
          margin: 0 auto 18px auto;
        ",
          
          "Explore your dataset, visualize patterns, perform statistical tests, and model relationships in one interactive platform."
        ),
        
        div(
          style = "
          display: inline-block;
          background: rgba(255,255,255,0.14);
          border: 1px solid rgba(255,255,255,0.25);
          padding: 8px 18px;
          border-radius: 30px;
          font-size: 13px;
        ",
          
          "✨ Explore • Visualize • Test • Model"
        )
      ),
      
      
      fluidRow(
        
        column(
          width = 3,
          
          div(
            style = "
            background: white;
            padding: 22px;
            border-radius: 16px;
            min-height: 160px;
            margin-bottom: 20px;
            box-shadow: 0 5px 18px rgba(34,51,84,0.08);
            text-align: center;
          ",
            
            h2("📂"),
            
            h4("Data Exploration"),
            
            p(
              "Upload CSV or Excel datasets and inspect observations, variables and missing values."
            )
          )
        ),
        
        
        column(
          width = 3,
          
          div(
            style = "
            background: white;
            padding: 22px;
            border-radius: 16px;
            min-height: 160px;
            margin-bottom: 20px;
            box-shadow: 0 5px 18px rgba(34,51,84,0.08);
            text-align: center;
          ",
            
            h2("📊"),
            
            h4("Data Visualization"),
            
            p(
              "Explore distributions and patterns using interactive statistical plots."
            )
          )
        ),
        
        
        column(
          width = 3,
          
          div(
            style = "
            background: white;
            padding: 22px;
            border-radius: 16px;
            min-height: 160px;
            margin-bottom: 20px;
            box-shadow: 0 5px 18px rgba(34,51,84,0.08);
            text-align: center;
          ",
            
            h2("🧪"),
            
            h4("Hypothesis Testing"),
            
            p(
              "Perform One-Sample and Two-Sample T-tests and Z-tests."
            )
          )
        ),
        
        
        column(
          width = 3,
          
          div(
            style = "
            background: white;
            padding: 22px;
            border-radius: 16px;
            min-height: 160px;
            margin-bottom: 20px;
            box-shadow: 0 5px 18px rgba(34,51,84,0.08);
            text-align: center;
          ",
            
            h2("📈"),
            
            h4("Relationship Modeling"),
            
            p(
              "Analyze correlation, linear regression and model diagnostics."
            )
          )
        )
      ),
      
      
      div(
        style = "
        background: white;
        padding: 22px;
        border-radius: 16px;
        border-left: 5px solid #6c63a8;
        box-shadow: 0 5px 18px rgba(34,51,84,0.07);
        margin-top: 5px;
      ",
        
        h4("🚀 Getting Started"),
        
        p(
          "Begin by opening the Data Upload tab and upload a CSV or XLSX dataset. The same dataset will then be used across all analysis modules."
        )
      ),
      
      br()
    )
  ),
  
  # =========================
  # MODULE 1: DATA UPLOAD
  # =========================
  tabPanel(
    "📁 Data Upload",
    
    div(
      style = "
      background: white;
      padding: 24px;
      border-radius: 16px;
      box-shadow: 0 5px 18px rgba(34,51,84,0.08);
      margin-top: 20px;
      margin-bottom: 20px;
      border-left: 5px solid #6c63a8;
    ",
      
      h2(
        style = "margin-top: 0;",
        "📁 Upload & Preview Your Dataset"
      ),
      
      p(
        style = "color: #6b7280; margin-bottom: 0;",
        "Upload a CSV or XLSX file to explore your data before performing statistical analysis."
      )
    ),
    
    sidebarLayout(
      
      sidebarPanel(
        
        fileInput(
          inputId = "file",
          label = "Upload Dataset",
          accept = c(".csv", ".xlsx")
        ),
        
        checkboxInput(
          inputId = "header",
          label = "First row contains column names",
          value = TRUE
        ),
        
        tags$hr(),
        
        div(
          style = "
    background: #f8f9ff;
    padding: 18px;
    border-radius: 14px;
    border: 1px solid #e8eaf6;
    margin-top: 10px;
  ",
          
          h4(
            style = "
      margin-top: 0;
      margin-bottom: 15px;
      color: #435b8c;
      font-weight: 700;
    ",
            "📌 Dataset Information"
          ),
          
          div(
            style = "
      background: white;
      padding: 10px 12px;
      border-radius: 9px;
      margin-bottom: 8px;
    ",
            textOutput("file_name")
          ),
          
          div(
            style = "
      background: white;
      padding: 10px 12px;
      border-radius: 9px;
      margin-bottom: 8px;
    ",
            textOutput("file_format")
          ),
          
          div(
            style = "
      background: white;
      padding: 10px 12px;
      border-radius: 9px;
      margin-bottom: 8px;
    ",
            textOutput("row_count")
          ),
          
          div(
            style = "
      background: white;
      padding: 10px 12px;
      border-radius: 9px;
      margin-bottom: 8px;
    ",
            textOutput("column_count")
          ),
          
          div(
            style = "
      background: white;
      padding: 10px 12px;
      border-radius: 9px;
    ",
            textOutput("missing_count")
          )
        )
      ),
      
      mainPanel(
        
        div(
          style = "
    background: white;
    padding: 22px;
    border-radius: 16px;
    box-shadow: 0 5px 18px rgba(34,51,84,0.08);
    margin-bottom: 18px;
  ",
          
          h3(
            style = "
      margin-top: 0;
      color: #30456b;
      font-weight: 700;
    ",
            "👋 Welcome"
          ),
          
          p(
            style = "
      color: #6b7280;
      margin-bottom: 0;
    ",
            "Please upload a CSV or XLSX dataset to begin the analysis."
          )
        ),
        
        div(
          style = "
    background: white;
    padding: 22px;
    border-radius: 16px;
    box-shadow: 0 5px 18px rgba(34,51,84,0.08);
    border-top: 4px solid #6c63a8;
  ",
          
          h3(
            style = "
      margin-top: 0;
      color: #30456b;
      font-weight: 700;
    ",
            "🔍 Dataset Preview"
          ),
          
          p(
            style = "
      color: #6b7280;
      margin-bottom: 18px;
    ",
            "The table below displays the uploaded dataset. Use the controls to search, sort, and change the number of visible rows."
          ),
          
          DTOutput("preview")
        )
      )
    )
  ),
  
  # =========================
  # MODULE 2: DESCRIPTIVE STATISTICS
  # =========================
  tabPanel(
    "📋 Descriptive Statistics",
    
    div(
      style = "
      background: white;
      padding: 24px;
      border-radius: 16px;
      box-shadow: 0 5px 18px rgba(34,51,84,0.08);
      margin-top: 20px;
      margin-bottom: 20px;
      border-left: 5px solid #435b8c;
    ",
      
      h2(
        style = "margin-top: 0;",
        "📋 Descriptive Statistics"
      ),
      
      p(
        style = "
        color: #6b7280;
        margin-bottom: 0;
      ",
        "Summarize quantitative and qualitative variables to better understand your dataset."
      )
    ),
    
    sidebarLayout(
      
      sidebarPanel(
        
        h4("Analysis Settings"),
        
        radioButtons(
          inputId = "data_type",
          label = "Select Data Type:",
          choices = c(
            "Quantitative" = "numeric",
            "Qualitative" = "categorical"
          ),
          selected = "numeric"
        ),
        
        uiOutput("variable_selector")
      ),
      
      mainPanel(
        
        div(
          style = "
    background: white;
    padding: 22px;
    border-radius: 16px;
    box-shadow: 0 5px 18px rgba(34,51,84,0.08);
    border-top: 4px solid #6c63a8;
  ",
          
          h3(
            style = "
      margin-top: 0;
      color: #30456b;
      font-weight: 700;
    ",
            "📊 Statistical Summary"
          ),
          
          p(
            style = "
      color: #6b7280;
      margin-bottom: 15px;
    ",
            "Select a data type and variable to view its descriptive statistics."
          ),
          
          uiOutput("selected_variable_text"),
          
          br(),
          
          tableOutput("summary_table")
        )
      )
    )
  ),
  # =========================
  # MODULE 3: DATA VISUALIZATION
  # =========================
  tabPanel(
    "📊 Data Visualization",
    
    div(
      style = "
      background: white;
      padding: 24px;
      border-radius: 16px;
      box-shadow: 0 5px 18px rgba(34,51,84,0.08);
      margin-top: 20px;
      margin-bottom: 20px;
      border-left: 5px solid #526fa4;
    ",
      
      h2(
        style = "margin-top: 0;",
        "📊 Data Visualization"
      ),
      
      p(
        style = "
        color: #6b7280;
        margin-bottom: 0;
      ",
        "Visualize distributions, frequencies, and patterns in your dataset using appropriate statistical plots."
      )
    ),
    
    sidebarLayout(
      
      sidebarPanel(
        
        h4("Visualization Settings"),
        
        radioButtons(
          inputId = "plot_data_type",
          label = "Select Data Type:",
          choices = c(
            "Quantitative" = "numeric",
            "Qualitative" = "categorical"
          ),
          selected = "numeric"
        ),
        
        uiOutput("plot_variable_selector"),
        
        uiOutput("plot_type_selector"),
        
        uiOutput("bin_width_slider")
      ),
      
      mainPanel(
        
        div(
          style = "
      background: white;
      padding: 22px;
      border-radius: 16px;
      box-shadow: 0 5px 18px rgba(34,51,84,0.08);
      border-top: 4px solid #6c63a8;
    ",
          
          h3(
            style = "
        margin-top: 0;
        color: #30456b;
        font-weight: 700;
      ",
            "📈 Visualization Output"
          ),
          
          p(
            style = "
        color: #6b7280;
        margin-bottom: 18px;
      ",
            "Select a variable and plot type. The chart will update automatically."
          ),
          
          plotOutput(
            outputId = "dynamic_plot",
            height = "550px"
          )
        )
      )
    )
  )
  ,
  
  # =========================
  # MODULE 4: HYPOTHESIS TESTING
  # =========================
  
  tabPanel(
    "🧪 Hypothesis Testing",
    
    div(
      style = "
      background: white;
      padding: 24px;
      border-radius: 16px;
      box-shadow: 0 5px 18px rgba(34,51,84,0.08);
      margin-top: 20px;
      margin-bottom: 20px;
      border-left: 5px solid #6c63a8;
    ",
      
      h2(
        style = "margin-top: 0;",
        "🧪 Automated Hypothesis Testing"
      ),
      
      p(
        style = "
        color: #6b7280;
        margin-bottom: 0;
      ",
        "Perform One-Sample or Two-Sample hypothesis tests using T-tests or Z-tests and interpret the statistical results."
      )
    ),
    
    sidebarLayout(
      
      sidebarPanel(
        
        h4("Hypothesis Test Settings"),
        
        radioButtons(
          inputId = "sample_structure",
          label = "Select Sample Structure:",
          choices = c(
            "One-Sample" = "one",
            "Two-Sample" = "two"
          ),
          selected = "one"
        ),
        
        radioButtons(
          inputId = "test_type",
          label = "Select Test Type:",
          choices = c(
            "T-test" = "t",
            "Z-test" = "z"
          ),
          selected = "t"
        ),
        
        uiOutput("hypothesis_inputs"),
        
        radioButtons(
          inputId = "alternative",
          label = "Alternative Hypothesis:",
          choices = c(
            "Two-sided" = "two.sided",
            "Less than" = "less",
            "Greater than" = "greater"
          ),
          selected = "two.sided"
        ),
        
        actionButton(
          inputId = "run_test",
          label = "Run Hypothesis Test",
          class = "btn-primary"
        )
      ),
      
      
      mainPanel(
        
        div(
          style = "
      background: white;
      padding: 22px;
      border-radius: 16px;
      box-shadow: 0 5px 18px rgba(34,51,84,0.08);
      margin-bottom: 18px;
    ",
          
          h3(
            style = "
        margin-top: 0;
        color: #30456b;
        font-weight: 700;
      ",
            "🧪 Hypothesis Test Guidance"
          ),
          
          p(
            style = "
        color: #6b7280;
        margin-bottom: 15px;
      ",
            "Review the selected test setup before running the statistical analysis."
          ),
          
          uiOutput("test_guidance")
        ),
        
        div(
          style = "
      background: white;
      padding: 22px;
      border-radius: 16px;
      box-shadow: 0 5px 18px rgba(34,51,84,0.08);
      border-top: 4px solid #6c63a8;
    ",
          
          h3(
            style = "
        margin-top: 0;
        color: #30456b;
        font-weight: 700;
      ",
            "📊 Test Results"
          ),
          
          p(
            style = "
        color: #6b7280;
        margin-bottom: 18px;
      ",
            "The test statistic, p-value, and statistical conclusion will appear below after the test is run."
          ),
          
          tableOutput("hypothesis_result"),
          
          br(),
          
          div(
            style = "
        background: #f8f9ff;
        padding: 16px;
        border-radius: 12px;
        border-left: 4px solid #526fa4;
        margin-top: 10px;
      ",
            
            h4(
              style = "
          margin-top: 0;
          color: #435b8c;
          font-weight: 700;
        ",
              "💡 Statistical Conclusion"
            ),
            
            uiOutput("hypothesis_conclusion")
          )
        )
      )
    )
  ),
  
  # =========================
  # MODULE 5: RELATIONSHIP MODELING & REGRESSION
  # =========================
  
  tabPanel(
    "📈 Relationship & Regression",
    
    div(
      style = "
      background: white;
      padding: 24px;
      border-radius: 16px;
      box-shadow: 0 5px 18px rgba(34,51,84,0.08);
      margin-top: 20px;
      margin-bottom: 20px;
      border-left: 5px solid #526fa4;
    ",
      
      h2(
        style = "margin-top: 0;",
        "📈 Relationship Modeling & Regression"
      ),
      
      p(
        style = "
        color: #6b7280;
        margin-bottom: 0;
      ",
        "Explore relationships between quantitative variables using correlation analysis, scatterplots, linear regression, and model diagnostics."
      )
    ),
    
    sidebarLayout(
      
      sidebarPanel(
        
        h4("Relationship Analysis Settings"),
        
        radioButtons(
          inputId = "relationship_mode",
          label = "Select Analysis Mode:",
          choices = c(
            "Pairwise Analysis" = "pairwise",
            "Correlation Matrix" = "matrix"
          ),
          selected = "pairwise"
        ),
        
        
        # =========================
        # PAIRWISE ANALYSIS SETTINGS
        # =========================
        
        conditionalPanel(
          condition = "input.relationship_mode == 'pairwise'",
          
          uiOutput("x_variable_selector"),
          
          uiOutput("y_variable_selector"),
          
          radioButtons(
            inputId = "correlation_method",
            label = "Select Correlation Method:",
            choices = c(
              "Pearson" = "pearson",
              "Spearman" = "spearman"
            ),
            selected = "pearson"
          )
        ),
        
        
        # =========================
        # CORRELATION MATRIX SETTINGS
        # =========================
        
        conditionalPanel(
          condition = "input.relationship_mode == 'matrix'",
          
          numericInput(
            inputId = "matrix_variable_count",
            label = "Number of Variables:",
            value = 3,
            min = 2,
            max = 6,
            step = 1
          ),
          
          uiOutput("matrix_variable_selector"),
          
          radioButtons(
            inputId = "matrix_method",
            label = "Select Correlation Method:",
            choices = c(
              "Pearson" = "pearson",
              "Spearman" = "spearman"
            ),
            selected = "pearson"
          )
        )
      ),
      
      
      mainPanel(
        
        # =========================
        # PAIRWISE OUTPUT
        # =========================
        
        conditionalPanel(
          condition = "input.relationship_mode == 'pairwise'",
          
          div(
            style = "
        background: white;
        padding: 22px;
        border-radius: 16px;
        box-shadow: 0 5px 18px rgba(34,51,84,0.08);
        margin-bottom: 18px;
        border-top: 4px solid #6c63a8;
      ",
            
            h3(
              style = "
          margin-top: 0;
          color: #30456b;
          font-weight: 700;
        ",
              "🔗 Correlation Analysis"
            ),
            
            uiOutput("correlation_description"),
            
            br(),
            
            tableOutput("correlation_result"),
            
            br(),
            
            div(
              style = "
          background: #f8f9ff;
          padding: 16px;
          border-radius: 12px;
          border-left: 4px solid #526fa4;
        ",
              
              h4(
                style = "
            margin-top: 0;
            color: #435b8c;
            font-weight: 700;
          ",
                "💡 Correlation Interpretation"
              ),
              
              uiOutput("correlation_conclusion")
            )
          ),
          
          
          div(
            style = "
        background: white;
        padding: 22px;
        border-radius: 16px;
        box-shadow: 0 5px 18px rgba(34,51,84,0.08);
        margin-bottom: 18px;
      ",
            
            h3(
              style = "
          margin-top: 0;
          color: #30456b;
          font-weight: 700;
        ",
              "📊 Scatterplot"
            ),
            
            p(
              style = "
          color: #6b7280;
          margin-bottom: 15px;
        ",
              "Visualize the relationship between the selected X and Y variables."
            ),
            
            plotOutput(
              outputId = "scatter_plot",
              height = "450px"
            )
          ),
          
          
          div(
            style = "
        background: white;
        padding: 22px;
        border-radius: 16px;
        box-shadow: 0 5px 18px rgba(34,51,84,0.08);
        margin-bottom: 18px;
        border-top: 4px solid #526fa4;
      ",
            
            h3(
              style = "
          margin-top: 0;
          color: #30456b;
          font-weight: 700;
        ",
              "📈 Linear Regression Model"
            ),
            
            uiOutput("regression_equation"),
            
            br(),
            
            tableOutput("regression_coefficients"),
            
            br(),
            
            uiOutput("regression_statistics")
          ),
          
          
          div(
            style = "
        background: white;
        padding: 22px;
        border-radius: 16px;
        box-shadow: 0 5px 18px rgba(34,51,84,0.08);
        margin-bottom: 18px;
      ",
            
            h3(
              style = "
          margin-top: 0;
          color: #30456b;
          font-weight: 700;
        ",
              "🩺 Residual Diagnostics"
            ),
            
            h4("Residuals vs Fitted Values"),
            
            plotOutput(
              outputId = "residual_plot",
              height = "400px"
            ),
            
            br(),
            
            h4("Normal Q-Q Plot"),
            
            plotOutput(
              outputId = "qq_plot",
              height = "400px"
            )
          )
        ),
        
        
        # =========================
        # CORRELATION MATRIX OUTPUT
        # =========================
        
        conditionalPanel(
          condition = "input.relationship_mode == 'matrix'",
          
          div(
            style = "
        background: white;
        padding: 22px;
        border-radius: 16px;
        box-shadow: 0 5px 18px rgba(34,51,84,0.08);
        margin-bottom: 18px;
        border-top: 4px solid #6c63a8;
      ",
            
            h3(
              style = "
          margin-top: 0;
          color: #30456b;
          font-weight: 700;
        ",
              "🧮 Correlation Matrix"
            ),
            
            p(
              style = "
          color: #6b7280;
          margin-bottom: 18px;
        ",
              "Choose the number of quantitative variables first, then select exactly that number of variables."
            ),
            
            tableOutput("correlation_matrix")
          ),
          
          
          div(
            style = "
        background: white;
        padding: 22px;
        border-radius: 16px;
        box-shadow: 0 5px 18px rgba(34,51,84,0.08);
      ",
            
            h3(
              style = "
          margin-top: 0;
          color: #30456b;
          font-weight: 700;
        ",
              "🔍 Scatterplot Matrix"
            ),
            
            p(
              style = "
          color: #6b7280;
          margin-bottom: 15px;
        ",
              "Compare pairwise relationships among the selected quantitative variables."
            ),
            
            plotOutput(
              outputId = "scatter_matrix",
              height = "650px"
            )
          )
        )
      )
    )
  ),
  
  # =========================
  # MODULE 6: USER GUIDE
  # =========================
  
  tabPanel(
    "📘 User Guide",
    
    fluidPage(
      
      div(
        style = "
        background: white;
        padding: 24px;
        border-radius: 16px;
        box-shadow: 0 5px 18px rgba(34,51,84,0.08);
        margin-top: 20px;
        margin-bottom: 24px;
        border-left: 5px solid #6c63a8;
      ",
        
        h2(
          style = "margin-top: 0;",
          "📘 Dashboard User Guide"
        ),
        
        p(
          style = "
          color: #6b7280;
          margin-bottom: 0;
        ",
          "Learn how to use each module correctly and select appropriate variables for statistical analysis."
        )
      ),
      
      
      # =========================
      # GETTING STARTED
      # =========================
      
      div(
        style = "
    background: white;
    padding: 22px;
    border-radius: 16px;
    box-shadow: 0 5px 18px rgba(34,51,84,0.07);
    margin-bottom: 20px;
  ",
        
        h3(
          style = "
      margin-top: 0;
      color: #30456b;
      font-weight: 700;
    ",
          "🚀 1. Getting Started"
        ),
        
        p(
          "The dashboard contains five main analysis modules:"
        ),
        
        tags$ol(
          tags$li("📁 Data Upload"),
          tags$li("📋 Descriptive Statistics"),
          tags$li("📊 Data Visualization"),
          tags$li("🧪 Hypothesis Testing"),
          tags$li("📈 Relationship & Regression")
        ),
        
        div(
          class = "alert alert-info",
          
          strong("Getting Started: "),
          
          "Begin by uploading a dataset in the Data Upload tab. The uploaded dataset will then be used throughout the other modules."
        )
      ),
      
      
      # =========================
      # MODULE 1 GUIDE
      # =========================
      
      div(
        style = "
    background: white;
    padding: 22px;
    border-radius: 16px;
    box-shadow: 0 5px 18px rgba(34,51,84,0.07);
    margin-bottom: 20px;
  ",
        
        h3(
          style = "
      margin-top: 0;
      color: #30456b;
      font-weight: 700;
    ",
          "📁 2. Data Upload"
        ),
        
        h4("Purpose"),
        
        p(
          "This module allows users to upload a dataset before performing statistical analysis."
        ),
        
        h4("Supported File Types"),
        
        tags$ul(
          tags$li("CSV (.csv)"),
          tags$li("Excel (.xlsx)")
        ),
        
        h4("Dataset Preview"),
        
        p(
          "After uploading a file, the dashboard displays basic dataset information including the file name, file format, number of rows, number of columns, and total missing values."
        ),
        
        p(
          "The dataset preview can be searched, sorted, and horizontally scrolled to inspect the uploaded observations and variables."
        ),
        
        div(
          class = "alert alert-info",
          
          strong("Tip: "),
          
          "Review the dataset structure and variable names before proceeding to the analysis modules."
        )
      ),
      
      
      # =========================
      # MODULE 2 GUIDE
      # =========================
      
      div(
        style = "
    background: white;
    padding: 22px;
    border-radius: 16px;
    box-shadow: 0 5px 18px rgba(34,51,84,0.07);
    margin-bottom: 20px;
  ",
        
        h3(
          style = "
      margin-top: 0;
      color: #30456b;
      font-weight: 700;
    ",
          "📋 3. Descriptive Statistics"
        ),
        
        h4("Purpose"),
        
        p(
          "This module summarizes quantitative and qualitative variables."
        ),
        
        h4("Quantitative Data"),
        
        p(
          "Quantitative data are numerical measurements where values represent meaningful quantities and can be used for mathematical or statistical analysis."
        ),
        
        div(
          class = "alert alert-warning",
          
          p(
            "Important: A variable stored as numbers is not automatically a continuous quantitative measurement. The dashboard automatically excludes identifier variables and detects simple numerically coded categorical variables based on their value patterns. These coded variables are treated as qualitative variables rather than continuous quantitative variables."
          )
        ),
        
        p(
          "The application can display valid observations, missing values, mean, median, standard deviation, variance, minimum, quartiles, and maximum."
        ),
        
        h4("Qualitative Data"),
        
        p(
          "Qualitative data represent categories or groups. These may be stored as text, factors, or simple numerical codes representing categories or ordered levels."
        ),
        
        p(
          "The application displays category frequencies, percentages, missing categories where applicable, and the total."
        )
      ),
      
      
      # =========================
      # MODULE 3 GUIDE
      # =========================
      
      div(
        style = "
    background: white;
    padding: 22px;
    border-radius: 16px;
    box-shadow: 0 5px 18px rgba(34,51,84,0.07);
    margin-bottom: 20px;
  ",
        
        h3(
          style = "
      margin-top: 0;
      color: #30456b;
      font-weight: 700;
    ",
          "📊 4. Data Visualization"
        ),
        
        h4("Purpose"),
        
        p(
          "This module creates graphical summaries of quantitative and qualitative variables."
        ),
        
        h4("Quantitative Plots"),
        
        tags$ul(
          tags$li(
            strong("Histogram: "),
            "shows the distribution of numerical data using bins."
          ),
          tags$li(
            strong("Density Curve: "),
            "shows a smooth representation of the numerical distribution."
          )
        ),
        
        div(
          class = "alert alert-info",
          
          strong("Histogram Tip: "),
          
          "The bin width can be adjusted using the slider to explore the distribution at different levels of detail."
        ),
        
        h4("Qualitative Plots"),
        
        tags$ul(
          tags$li(
            strong("Bar Chart: "),
            "compares the frequencies of different categories."
          ),
          tags$li(
            strong("Pie Chart: "),
            "shows the proportions of different categories."
          )
        )
      ),
      
      
      # =========================
      # MODULE 4 GUIDE
      # =========================
      
      div(
        style = "
    background: white;
    padding: 22px;
    border-radius: 16px;
    box-shadow: 0 5px 18px rgba(34,51,84,0.07);
    margin-bottom: 20px;
  ",
        
        h3(
          style = "
      margin-top: 0;
      color: #30456b;
      font-weight: 700;
    ",
          "🧪 5. Hypothesis Testing"
        ),
        
        h4("Purpose"),
        
        p(
          "This module performs One-Sample and Two-Sample T-tests or Z-tests."
        ),
        
        h4("One-Sample"),
        
        p(
          "A One-Sample test compares the mean of one quantitative sample with a hypothesised mean."
        ),
        
        p(
          "Users may use all observations or filter the quantitative variable using one qualitative group."
        ),
        
        h4("Two-Sample"),
        
        p(
          "A Two-Sample test compares the means of two selected groups."
        ),
        
        p(
          "Select one quantitative variable, one qualitative grouping variable, and two different groups."
        ),
        
        h4("T-test and Z-test"),
        
        tags$ul(
          tags$li(
            strong("T-test: "),
            "used when the population standard deviation is unknown."
          ),
          tags$li(
            strong("Z-test: "),
            "used when the population standard deviation is known."
          )
        ),
        
        h4("Alternative Hypothesis"),
        
        tags$ul(
          tags$li(
            strong("Two-sided: "),
            "tests whether the population mean is different from the hypothesised value."
          ),
          tags$li(
            strong("Less than: "),
            "tests whether the population mean is lower than the hypothesised value."
          ),
          tags$li(
            strong("Greater than: "),
            "tests whether the population mean is higher than the hypothesised value."
          )
        ),
        div(
          class = "alert alert-info",
          
          strong("Decision Rule: "),
          
          "At the 0.05 significance level, reject the null hypothesis when the p-value is less than 0.05. Otherwise, fail to reject the null hypothesis.",
          
          tags$br(),
          tags$br(),
          
          "Very small p-values may be displayed as < 0.001 rather than 0, because a displayed value of zero may result from rounding."
        )
      ),
      
      
      # =========================
      # MODULE 5 GUIDE
      # =========================
      
      div(
        style = "
    background: white;
    padding: 22px;
    border-radius: 16px;
    box-shadow: 0 5px 18px rgba(34,51,84,0.07);
    margin-bottom: 20px;
  ",
        
        h3(
          style = "
      margin-top: 0;
      color: #30456b;
      font-weight: 700;
    ",
          "📈 6. Relationship & Regression"
        ),
        
        h4("Purpose"),
        
        p(
          "This module examines relationships between quantitative variables using correlation and linear regression."
        ),
        
        h4("Pairwise Analysis"),
        
        p(
          "Pairwise Analysis examines two quantitative variables in detail."
        ),
        
        tags$ol(
          tags$li("Select the X variable."),
          tags$li("Select the Y variable."),
          tags$li("Select Pearson or Spearman correlation."),
          tags$li("Review the correlation coefficient and p-value."),
          tags$li("Review the scatterplot."),
          tags$li("Review the linear regression results and diagnostics.")
        ),
        
        h4("Correlation Methods"),
        
        tags$ul(
          tags$li(
            strong("Pearson: "),
            "measures the strength and direction of a linear relationship between two continuous quantitative variables."
          ),
          
          tags$li(
            strong("Spearman: "),
            "is a rank-based method used to measure the strength and direction of a monotonic relationship. It is suitable for ordinal variables or quantitative variables when a rank-based method is more appropriate. However, only variables available for relationship analysis can be selected in this dashboard."
          )
        ),
        
        div(
          class = "alert alert-warning",
          
          strong("Variable Selection: "),
          
          "Select meaningful quantitative variables for correlation analysis. Avoid identifier variables and variables that do not represent meaningful numerical measurements."
        ),
        
        h4("Correlation Strength"),
        
        tableOutput("correlation_guide_table"),
        
        h4("Linear Regression"),
        
        p(
          "Linear regression models the relationship between two meaningful quantitative variables, where X is the predictor variable and Y is the response variable."
        ),
        
        p(
          "The application fits the model Y = β₀ + β₁X, where β₀ is the intercept and β₁ represents the expected change in Y for a one-unit increase in X."
        ),
        
        p(
          "The regression output includes coefficients, p-values, the regression equation, R-squared, adjusted R-squared, model p-value, residual plot, and Normal Q-Q plot."
        ),
        
        div(
          class = "alert alert-info",
          
          strong("Regression Diagnostics: "),
          
          "Use the Residuals vs Fitted plot to examine the pattern of residuals and the Normal Q-Q plot to assess whether the residuals are approximately normally distributed."
        ),
        
        div(
          class = "alert alert-warning",
          
          strong("Variable Selection: "),
          
          "Select meaningful quantitative variables for both X and Y. Avoid identifier variables and variables that do not represent meaningful numerical measurements."
        ),
        
        h4("Correlation Matrix"),
        
        p(
          "Correlation Matrix mode allows users to examine several quantitative variables at the same time."
        ),
        
        tags$ol(
          tags$li("Choose the number of variables."),
          tags$li("Select exactly that number of quantitative variables."),
          tags$li("Choose Pearson or Spearman correlation."),
          tags$li("Review the correlation matrix and scatterplot matrix.")
        ),
        
        div(
          class = "alert alert-info",
          
          strong("Maximum of Six Variables: "),
          
          "The dashboard limits the correlation matrix to a maximum of six variables to maintain readability and a clear user interface. This is not a statistical limitation of correlation analysis."
        ),
        
        div(
          class = "alert alert-warning",
          
          strong("Recommended Variable Selection: "),
          
          "Select meaningful quantitative variables that are appropriate for correlation analysis. Avoid identifier variables and variables that do not represent meaningful numerical measurements."
        )
      ),
      
      
      # =========================
      # TROUBLESHOOTING
      # =========================
      
      div(
        style = "
    background: white;
    padding: 22px;
    border-radius: 16px;
    box-shadow: 0 5px 18px rgba(34,51,84,0.07);
    margin-bottom: 20px;
  ",
        
        h3(
          style = "
      margin-top: 0;
      color: #30456b;
      font-weight: 700;
    ",
          "🛠️ 7. Troubleshooting"
        ),
        
        p(
          "Use the following checks if an analysis does not produce the expected output."
        ),
        
        tags$ul(
          tags$li(
            strong("No variables appear: "),
            "confirm that a valid dataset has been uploaded."
          ),
          
          tags$li(
            strong("Analysis cannot run: "),
            "check whether the selected variables contain enough valid observations."
          ),
          
          tags$li(
            strong("Pairwise Analysis: "),
            "ensure that X and Y are different variables."
          ),
          
          tags$li(
            strong("Two-Sample Test: "),
            "ensure that Group 1 and Group 2 are different."
          ),
          
          tags$li(
            strong("Correlation Matrix: "),
            "select exactly the number of variables requested."
          )
        ),
        
        div(
          class = "alert alert-info",
          
          strong("Tip: "),
          
          "If an error occurs, review the selected variable types and confirm that they are appropriate for the chosen statistical analysis."
        )
      ),
      
      
      # =========================
      # RECOMMENDED WORKFLOW
      # =========================
      
      div(
        style = "
    background: white;
    padding: 22px;
    border-radius: 16px;
    box-shadow: 0 5px 18px rgba(34,51,84,0.07);
    margin-bottom: 20px;
  ",
        
        h3(
          style = "
      margin-top: 0;
      color: #30456b;
      font-weight: 700;
    ",
          "✅ 8. Recommended Workflow"
        ),
        
        p(
          "For a clear and systematic analysis, users are recommended to follow these steps:"
        ),
        
        tags$ol(
          tags$li(
            strong("Upload and inspect the dataset. "),
            "Check the dataset structure, variables, and missing values."
          ),
          
          tags$li(
            strong("Review descriptive statistics. "),
            "Understand the main characteristics of the selected variables."
          ),
          
          tags$li(
            strong("Visualize the variables. "),
            "Explore distributions, frequencies, and patterns using appropriate plots."
          ),
          
          tags$li(
            strong("Perform hypothesis testing if required. "),
            "Select an appropriate test according to the research question and available information."
          ),
          
          tags$li(
            strong("Explore relationships and regression. "),
            "Investigate associations between meaningful quantitative variables."
          )
        ),
        
        div(
          class = "alert alert-info",
          
          strong("Reminder: "),
          
          "Always select appropriate variable types and interpret statistical results according to the meaning and context of the data."
        )
      ),
      
      tags$br()
    )
  )
)