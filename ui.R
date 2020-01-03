#
# This is the user-interface definition of a Shiny web application. 
#

# TO do:
# - Fix the double name problem with casei (also add field for basonyms?)
#
# Deploy on Swifter


library(shiny)
source("data.R", local = TRUE)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel(""),
    
    
    sidebarLayout(
        
        # Sidebar with options
        
        sidebarPanel(
            h3("Enter a species name"),
            autocomplete_input("auto_basonym",
                               "Basonym (old species name)",
                               taxtable_intern$basonym %>% sort(),
                               max_options = 50),
            actionButton("basonym_search", "Search"),
            p(""),
            p("or"),
            p(""), 
            autocomplete_input("auto_newname",
                               "New name",
                               taxtable_intern$new_name %>% sort(),
                               max_options = 50),
            actionButton("newname_search", "Search")
            
        ),
        
        
        # Output
        mainPanel(
            # Formatting
            htmlOutput("properties"),
            htmlOutput("other_species_text"),
            DT::dataTableOutput("other_species_table")
        )
    ),
    
    
    # Footer
    hr(),
    
    # Citation
    div(style="text-align:center",
        tags$b("This application is made possible due to the valuable contributions of all co-authors mentioned in the following publication. Please cite this resource if applicable:")),
    br(),
    div(
        style = "text-align:center",
        "Zheng J., Wittouck S., Salvetti E.",
        tags$i("et al.,"),
        "(2020).",
        tags$i(
            "A taxonomic note on the genus Lactobacillus: Description of 23 novel genera, emended description of the genus Lactobacillus Beijerink 1901, and union of Lactobacillaceae and Leuconostocaceae."
        ),
        tags$b("Under revision.")
    ),
    br(),
    
    
    # Bugs and mistakes
    div(
        style = "text-align:center",
        "Please report mistakes and bugs via",
        tags$a(href="mailto:wuyts@embl.de", "e-mail"),
        " or open a new",
        tags$a(href="https://github.com/swuyts/lactotax/issues", "Github issue.")
    ),
    hr(),
    
    
    # Development
    div(
        style = "text-align:center",
        tags$small("Developed by"),
        tags$small(tags$a(href="https://www.sanderwuyts.com", "dr. Sander Wuyts")),
        tags$small("and hosted at "),
        tags$small(tags$a(href="http://www.bork.embl.de", "EMBL (Bork Group)."))
        
    )
    
    
    

    
    
    
)
)

