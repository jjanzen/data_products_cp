library(shiny)
library(ggplot2)

ctr <- function(clicks, loads) {
     clicks/loads
}

t_test_stat_sig <- function(test_ctr, control_ctr, se_control_ctr){
    t_stat_ctr <- ((test_ctr - control_ctr)/se_control_ctr)
    two_tail_95 <- 1.96
    ifelse(abs(t_stat_ctr) > two_tail_95, TRUE, FALSE)
}

chi_square_stat_sig <- function(chi_sqr_ctr){
    chi_sqr95 <- 3.84
    ifelse(chi_sqr_ctr > chi_sqr95, TRUE, FALSE)
}

se <- function(ctr, loads_one, loads_two){
    factor_sqrt <- sqrt(ctr*(1-ctr))
    pooled_ctr <- (1/loads_one + 1/loads_two)
    factor_sqrt * pooled_ctr
}

shinyServer(
    function(input, output) {
        test_clicks <- reactive(input$test_clicks)
        test_loads <- reactive(input$test_loads)
        control_clicks <- reactive(input$control_clicks)
        control_loads <- reactive(input$control_loads)
        test_ctr <- reactive({ctr(test_clicks, test_loads)})
        control_ctr <- reactive({ctr(control_clicks, control_loads)})
        pooled_sample_proportion <- reactive((control_clicks+test_clicks)/(control_loads+test_loads))
        
        # chi-square significance
        control_expected_clicks <- reactive(input$control_loads/(input$control_loads + input$test_loads)*(input$control_clicks + input$test_clicks))
        test_expected_clicks <- reactive(input$test_loads/(input$control_loads + input$test_loads)*(input$control_clicks + input$test_clicks))
        chi_sqr_ctr <- reactive(((control_expected_clicks()-input$control_clicks)^2)/control_expected_clicks() + ((test_expected_clicks()-input$test_clicks)^2)/test_expected_clicks())

        # t-test significance
        se_control_ctr <- reactive({se({ctr((input$control_clicks + input$test_clicks)
                                            ,(input$control_loads + input$test_loads))}
                              ,input$control_clicks, input$test_loads)})
        
        #se_test_ctr <- reactive({se({ctr(input$test_clicks, input$test_loads)}
        #                   ,input$test_clicks, input$control_loads)})
        t_test_test_ctr <- reactive(input$test_clicks/input$test_loads)
        t_test_control_ctr <- reactive(input$control_clicks/input$control_loads)

        output$significant_t_test <- renderText({
            if(input$goButton > 0) {
                #t_test_stat_sig(test_ctr(), control_ctr(), se_control_ctr())
                t_test_stat_sig(t_test_test_ctr(), t_test_control_ctr(), se_control_ctr() )
            }
        })
        
        output$significant_chi_square <- renderText({
            if(input$goButton > 0) {
                chi_square_stat_sig(chi_sqr_ctr())
            }
        })
        
        output$test_click_rate <- renderText({
            if(input$goButton > 0) {
                 ctr(input$test_clicks, input$test_loads)
            }
        })
        
        output$control_click_rate <- renderText({
            if(input$goButton > 0) {
                ctr(input$control_clicks, input$control_loads)
            }
        })
        
        output$newHist <- renderPlot({
            if(input$goButton > 0) {
                qplot(x=c("test","control"), y=c({ctr(input$test_clicks, input$test_loads)}
                                                 , {ctr(input$control_clicks, input$control_loads)}),
                      main="Click-through-rate for Test", 
                      xlab="", ylab="CTR", fill=c("test","control"),
                      stat="identity", position="dodge",
                      geom="bar")     
            }

        })

    }   
)

