#
# This is the server logic of a Shiny weLactobacillus mudanjiangensisb application. 
#

library(shiny)
source("data.R", local = TRUE)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {""
    
    # Make empty reactiveValues
    search <- reactiveValues(filtered_table = NULL)
    
    # If basonym search is performed
    observeEvent(input$basonym_search, {
        search$filtered_table <- taxtable_intern %>% 
            filter(basonym == input$auto_basonym)
    })
    
    # If new name search is performed
    observeEvent(input$newname_search, {
        search$filtered_table <- taxtable_intern %>% 
            filter(new_name == input$auto_newname)
    })
    
    
    # Generate general properties
    output$properties <- renderUI({
        # Return nothing is no search is performed
        if (is.null(search$filtered_table)) return()
        
        # Get names
        species <- search$filtered_table %>% pull(new_name) %>% str_c("<i>", ., "</i>")
        basonym <- search$filtered_table %>% pull(basonym) %>% str_c("<b>Basonym (old species name): </b>", "<i>", ., "</i>")
        typestrain <- search$filtered_table %>% pull(`Type strain`) %>% str_c("<b>Type strain: </b>", .)
        
        # Additional information
        year <- search$filtered_table %>% pull(`year of effective or valid publication`) %>% str_c("<b>Year of valid publication: </b>", .)
        doi <- search$filtered_table %>% 
            pull(`valid description or effective publication (DOI of most recent or most relevant record)`) %>% 
            str_c("<b>DOI: </b>", '<a href="https://doi.org/', ., '">', ., "</a>") 
        
        # Get accessions
        rRNA <- search$filtered_table %>% pull(`16S rRNA accession no`) %>% 
            str_c("<b>Genbank 16S rRNA gene accession number: </b>", '<a href="https://www.ncbi.nlm.nih.gov/nuccore/', ., '">', ., "</a>")
        genome <- search$filtered_table %>% pull(`Genome Accession Number Type Strain`) %>% 
            str_c("<b>Genbank genome accession number: </b>", '<a href="https://www.ncbi.nlm.nih.gov/nuccore/', ., '">', ., "</a>")
        
        
        HTML(str_c("<hr>",
                   "<h1>",
                   species,
                   "</h1>",
                   "<hr>",
                   basonym,
                   "<br/>",
                   typestrain,
                   "<h2>Accession numbers</h2>",
                   rRNA,
                   "<br/>",
                   genome,
                   "<h2>Additional information</h2>",
                   year,
                   "<br/>",
                   doi
                   )
        )
    })
    
    # Header for other species in same genus 
    output$other_species_text <- renderUI({
        # Return nothing is no search is performed
        if (is.null(search$filtered_table)) return()
        
        HTML("<h2>Other species in the same genus</h2>
             <br/>")
    
    })
    
    # Data for other species in same genus
    output$other_species_table <- DT::renderDataTable({
        if (is.null(search$filtered_table)) return()
        
        genus_name <- search$filtered_table %>% pull(`proposed new genus name`) %>% .[1]
        
        taxtable_intern %>% 
            filter(`proposed new genus name` == genus_name) %>% 
            select(`proposed new genus name`, `proposed new species name`) %>% 
            rename(Genus = `proposed new genus name`,
                   Species = `proposed new species name`) %>% 
            DT::datatable(., options = list(dom = "tpl"))  
    })
    
    
    
    # Table output
    output$taxTable <- DT::renderDataTable({
        DT::datatable(taxtable[, input$show_vars, drop = FALSE], 
                      options = list(orderClasses = TRUE))
    })
})
