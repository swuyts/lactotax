library(shiny)
source("data.R", local = TRUE)




# Define server logic 
shinyServer(function(input, output) {""
    
    # Make empty reactiveValues
    search <- reactiveValues(filtered_table = NULL)
    
    # If basonym search is performed
    observeEvent(input$basonym_search, {
        
          
        # Check if it is one of the obsoletes
        if (input$auto_basonym %in% obsolete_names) {
            
            search$filtered_table <- taxtable_intern %>% 
                filter(str_detect(`obsolete names`, input$auto_basonym))
            
        } else {
        
        search$filtered_table <- taxtable_intern %>% 
            filter(basonym == input$auto_basonym)
        }
        
    })
    
    
    # If new name search is performed
    observeEvent(input$newname_search, {
        search$filtered_table <- taxtable_intern %>% 
            filter(new_name == input$auto_newname)
    })
    
    
    # Generate general properties
    output$properties <- renderUI({
        # Return introtext when no search is performed
        if (is.null(search$filtered_table)) {
            return(HTML(welcome_text))
        }
        
        # Get name
        species <- search$filtered_table %>% pull(new_name) %>% str_c("<i>", ., "</i>")
        # Get type strains
        typestrain <- search$filtered_table %>% pull(`Type strain`) %>% str_c("<b>Type strain: </b>", .)
        
        
        # Check for basonyms
        if(!is.na(search$filtered_table %>% pull(`obsolete names`))){
            
            # Extract all basonyms
            additional_basonyms <- search$filtered_table %>% 
                pull(`obsolete names`) %>% 
                str_replace_all(";", ",")
            
            # Merge with "regular" basonym
            basonym <- search$filtered_table %>% 
                pull(basonym) %>% 
                str_c("<b>Basonyms (old species names): </b>", "<i>", ., ", ", additional_basonyms, "</i>")
            
            # Get dois for rejection
            dois <- search$filtered_table %>% 
                pull(`reference for obsolete names`) %>% 
                str_split(";") %>% 
                unlist() %>% 
                str_squish() %>% 
                str_c('<a href="https://doi.org/', ., '">', ., "</a>") %>% 
                str_c(collapse = ", ")
            
            # Add to string
            basonym <- basonym %>% 
                str_c(.,
                      "<br/> <b>DOI for name rejection: </b>", dois)
            
            
            
        } else {
            
            basonym <- search$filtered_table %>% 
            pull(basonym) %>% 
            str_c("<b>Basonym (old species name): </b>", "<i>", ., "</i>")
            
        }
        
        
        # Additional information
        year <- search$filtered_table %>% pull(`year of effective or valid publication`) %>% str_c("<b>Year of valid or effective publication: </b>", .)
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
                   typestrain,
                   "<br/><br/>",
                   basonym,
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
        
        HTML("<h2>Other species and subspecies in the same genus</h2>
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
