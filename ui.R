library(shiny)
source("data.R", local = TRUE)

# Define UI for application
shinyUI(fluidPage(
    
    # Application title
    titlePanel(""),
    
    
    sidebarLayout(
        
        # Sidebar with options
        
        sidebarPanel(
            h3("Enter a species name"),
            selectizeInput("auto_basonym",
                           "Basonym (old species name)",
                           taxtable_intern$basonym %>% 
                               c(., obsolete_names) %>% 
                               sort(),
                           options = list(
                               placeholder = 'e.g. Lactobacillus sanfranciscensis',
                               onInitialize = I('function() { this.setValue(""); }'),
                               selectOnTab = T)),
            actionButton("basonym_search", "Search"),
            p(""),
            p("or"),
            p(""), 
            selectizeInput("auto_newname",
                           "New name",
                           taxtable_intern$new_name %>% sort(),
                           options = list(
                               placeholder = 'e.g. Fructilactobacillus sanfranciscensis',
                               onInitialize = I('function() { this.setValue(""); }'),
                               selectOnTab = T)),
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
        tags$a(href="https://doi.org/10.1099/ijsem.0.004107",
               tags$b("https://doi.org/10.1099/ijsem.0.004107"),
               target="_blank"
        ),
    ),
    br(),
    
    
    # Logos
    
    div(
        style = "text-align:center",
        tags$a(href="https://lebeerlab.com/",
               tags$img(src="university-of-antwerp.png", width = 190, height = 60, alt = "University of Antwerp: Lebeer lab", hspace = 20),
               target="_blank"
        ),
        tags$a(href="https://www.ualberta.ca/agriculture-life-environment-sciences/about-us/contact-us/facultylecturer-directory/michael-gaenzle",
               tags$img(src="university-of-alberta.png", width = 200, height = 50, alt = "University of Alberta: Gaenzle lab", hspace = 20),
               target="_blank"
        ),
        tags$a(href="http://www.dbt.univr.it/?ent=persona&id=145&lang=en",
               tags$img(src="university-of-verona.png", width = 200, height = 70, alt = "University of Verona: Felis lab", hspace = 20),
               target="_blank"
        ),
        br(),
        tags$a(href="https://distal.unibo.it/it",
               tags$img(src="unibo.png", width = 150, height = 120, alt = "University of Bologna", hspace = 20),
               target="_blank"
        ),
        tags$a(href="https://site.unibo.it/subcommittee-lactobacillus-bifidobacterium/en",
               tags$img(src="iscp.png", width = 120, height = 120, alt = "ISCP", hspace = 20),
               target="_blank"
        ),
        
        
    ),
    hr(),
    
    # Bugs and mistakes
    div(
        style = "text-align:center",
        "Last updated on: ",
        tags$b(str_c(db_version %>% day,
              db_version %>% month(label = T),
              db_version %>% year,
              sep = " ")),
        br(),
        br(),
        "Please report mistakes and bugs via",
        tags$a(href="mailto:wuyts@embl.de", "e-mail"),
        " or open a new",
        tags$a(href="https://github.com/swuyts/lactotax/issues", "Github issue.", target="_blank")
    ),
    
    # Development
    div(
        style = "text-align:center",
        tags$small("Developed by"),
        tags$small(tags$a(href="https://www.sanderwuyts.com", "dr. Sander Wuyts", target="_blank")),
        tags$small("and hosted by "),
        tags$small(tags$a(href="http://www.bork.embl.de", "EMBL (Bork Group)", target="_blank")),
        tags$small(", "),
        tags$small(tags$a(href="https://www.ualberta.ca/agriculture-life-environment-sciences", "Faculty of ALES (UofA)", target="_blank")),
        tags$small("and "),
        tags$small(tags$a(href="https://lebeerlab.com/", "UAntwerp (Lebeer lab)", target="_blank"))
        
        
    )
    
)
)

