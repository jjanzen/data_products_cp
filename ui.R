shinyUI(pageWithSidebar(
    headerPanel("Web AB Test"),
    sidebarPanel(
        numericInput('control_loads', 'control_loads', 0, min=0, step=1),
        numericInput('control_clicks', 'control_clicks', 0, min=0, step=1),
    #numericInput('control_thx', 'control_thx', 0, min=0, step=1),
    numericInput('test_loads', 'test_loads', 0, min=0, step=1),
    numericInput('test_clicks', 'test_clicks', 0, min=0, step=1),
    #numericInput('test_thx', 'test_thx', 0, min=0, step=1),
    actionButton("goButton", "Go!")
    ),
    mainPanel(
        h3('Results of Test'),
        h3(' '),
        h4('Statisically Significant T-test'),
        verbatimTextOutput("significant_t_test"),
        h4('Statisically Significant Chi-Square'),
        verbatimTextOutput("significant_chi_square"),
        h4('Control Click-through-rate'),
        verbatimTextOutput("control_click_rate"),
        h4('Test Click-through-rate'),
        verbatimTextOutput("test_click_rate"),
        plotOutput('newHist'),
        plotOutput('boxPlot')
    )
))
