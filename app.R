#Calls Needed Packages
library(shiny)
library(shinydashboard)
library(rmarkdown)



dropdownlist<- c(10:50)


################################################    UI - The look and feel of the page   ###############################################################
ui <- 
  dashboardPage(skin = "purple",
                dashboardHeader(title = "Report Title Goes Here", titleWidth = 275),
                #Sidebar Menu items and filters
                dashboardSidebar( width = 275,
                                  sidebarMenu(
                                    id = "tabs",
                                    selectInput(inputId = "selectiondropdown", label="Choose a value:",
                                                choices=dropdownlist, selected= dropdownlist[1] ),
                                    
                                    menuItem("Selection1", tabName = "selection1", icon = icon("table")),
                                    menuItem("Selection2 (With Expansion)", tabName = "sel2_w_expand",
                                             
                                             menuSubItem("SubMenu1", tabName = "submenu1_tab", icon = icon("table")),
                                             menuSubItem("SubMenu2", tabName = "submenu2_tab", icon = icon("table")),
                                             conditionalPanel(align = "center", "input.tabs == 'submenu2_tab'",
                                                              div(fluidRow(column(12, align = "center", uiOutput("regionlist2"))),
                                                                  style = "font-size: 65%; width: 95%; text-align: center; margin: 0 0 0 0")),
                                             menuSubItem("SubMenu3", tabName = "submenu3_tab", icon = icon("table")),
                                             menuSubItem("SubMenu4", tabName = "submenu4_tab", icon = icon("table")),
                                             conditionalPanel(align = "center", "input.tabs == 'state_tab'",
                                                              div(fluidRow(column(12, align = "center", uiOutput("countrylist"))),
                                                                  style = "font-size: 65%; width: 95%; text-align: center; margin: 0 0 0 0"))),
                                    menuItem("Selection3", tabName = "selection3", icon = icon("table"))

                                  )),
                #Report Body dataframes and buttons for each page
                dashboardBody(
                              tabsetPanel(type="tabs",
                                          tabPanel("Tab1", plotOutput("distPlot")),
                                          tabPanel("Tab2", 
                                                  includeMarkdown("readMe.Rmd") ),
                                          tabPanel("Tab3",
                                                   h3("How to Use This Report"),
                                                   includeMarkdown("Definitions.Rmd"))
                                          )  
                  
                  
                              )
  )








################################################    Server - What makes the app run: "Under the hood"   ###############################################################
server <- function(input, output, session) {

    output$distPlot <- renderPlot({
    x    <- faithful$waiting
    outnumber <- as.numeric(input$selectiondropdown)
    bins <- seq(min(x), max(x), length.out = outnumber)
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
    })
  
}






################################################    Run the app  ################################################    

#Run Shiny App with specified UI and Server
shinyApp(ui, server)