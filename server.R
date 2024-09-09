library(shiny)
library(DT)
library(ggplot2)

server <- function(input, output, session) {
  skills <- reactiveVal()
  
  observe({
    if(file.exists(dataFilePath)) {
      loadedSkills <- read.csv(dataFilePath, stringsAsFactors = FALSE)
      loadedSkills$SkillName <- as.character(loadedSkills$SkillName)
      skills(loadedSkills)
    } else {
      skills(data.frame(SkillName = character(), LowValue = numeric(), HighValue = numeric(), CurrentLevel = numeric(), NormalizedMin = numeric(), NormalizedMax = numeric(), NormalizedCurrent = numeric(), stringsAsFactors = FALSE))
    }
  })
  
  observeEvent(input$addSkill, {
    if(nchar(input$skillName) > 0) {
      # Normalize the current level based on the input low and high values
      normalizedCurrent <- round(((input$currentLevel - input$lowValue) / (input$highValue - input$lowValue)) * 100)
      normalizedMin <- 0  # Since LowValue is the minimum, it normalizes to 0
      normalizedMax <- 100  # Since HighValue is the maximum, it normalizes to 100
      
      newSkill <- data.frame(
        SkillName = input$skillName, 
        LowValue = input$lowValue, 
        HighValue = input$highValue, 
        CurrentLevel = input$currentLevel, 
        NormalizedMin = normalizedMin, 
        NormalizedMax = normalizedMax, 
        NormalizedCurrent = normalizedCurrent,
        stringsAsFactors = FALSE
      )
      
      currentSkills <- skills()
      if(!input$skillName %in% currentSkills$SkillName) {
        updatedSkills <- rbind(currentSkills, newSkill)
        skills(updatedSkills)
      }
    }
  })
  
  observeEvent(input$updateSkill, {
    selectedRow <- input$skillsTable_rows_selected
    if(length(selectedRow) == 1 && !is.null(input$currentLevel)) {
      currentSkills <- skills()
      if(selectedRow <= nrow(currentSkills)) {
        # Update the current level
        currentSkills[selectedRow, "CurrentLevel"] <- as.numeric(input$currentLevel)
        # Recalculate and update the normalized current level
        currentSkills[selectedRow, "NormalizedCurrent"] <- round(((as.numeric(input$currentLevel) - currentSkills[selectedRow, "LowValue"]) / (currentSkills[selectedRow, "HighValue"] - currentSkills[selectedRow, "LowValue"])) * 100)
        
        skills(currentSkills)
      } else {
        print("Selected row is out of range.")
      }
    } else if(length(selectedRow) != 1) {
      print("Please select a single row to update.")
    }
  })
  
  observeEvent(input$deleteSkill, {
    selectedRow <- input$skillsTable_rows_selected
    if(length(selectedRow)) {
      updatedSkills <- skills()[-selectedRow, ]
      skills(updatedSkills)
    }
  })
  
  observeEvent(input$saveData, {
    write.csv(skills(), dataFilePath, row.names = FALSE)
  })
  
  output$skillsTable <- renderDT({
    datatable(skills()[,1:4], selection = 'single', options = list(pageLength = 5, autoWidth = TRUE))
  }, server = FALSE)
  
  
  output$dynamicPlot <- renderUI({
    
    # Assume df is your data frame used for plotting
    height_per_row <- 28  # Set the height for each row
    
    total_height <- nrow(skills()) * height_per_row  # Calculate total height
    
    # Create plotOutput with dynamic height
    plotOutput("skillPlot", height = paste(total_height, "px", sep =""))
    
  })
  
  output$skillPlot <- renderPlot({
    
    df <- skills()
    
    library(showtext)
    font_add_google("MedievalSharp", "medievalsharp")
    
    showtext_auto()
    
    
    # Create the plot
    ggplot(df, aes(x = SkillName, y = NormalizedCurrent)) +
      geom_col(aes(y = NormalizedMax), fill = "#8d7a50", alpha = 0.9) +  # Grey bar for the max level
      geom_col(fill = "red") +  # Red bar for the current level
      geom_point(aes(y = NormalizedCurrent), fill = "gold2", size = 8, shape = 21) +  # Add point at the end of the red bar
      geom_point(aes(y = NormalizedMin), fill = "gold2", size = 10, shape = 21) +  # Add point at the end of the red bar
      geom_point(aes(y = NormalizedMax), fill = "gold2", size = 10, shape = 21) +  # Add point at the end of the red bar
      geom_text(aes(label = round(NormalizedCurrent), y = NormalizedMax + 5), 
                hjust = 0.5, color = "blue", size = 8, family = "medievalsharp", fontface = "bold") +  # Display normalized value
      coord_flip() +  # Flip coordinates to make the bars horizontal
      theme_minimal() +  # Minimal theme
      theme(
        panel.background = element_rect(fill = "cornsilk", colour = "NA"),  # Transparent background
        plot.background = element_rect(fill = "cornsilk", colour = NA),  # Transparent plot background
        panel.grid.major = element_blank(),  # Remove major grid lines
        panel.grid.minor = element_blank(),  # Remove minor grid lines
        axis.text.x = element_blank(),  # Remove x axis text
        text = element_text(size = 22, family = "medievalsharp")
      ) +
      labs(x = NULL, y = NULL)  # Remove axis labels
  })
  
  output$classImage <- renderUI({
    
    # Construct the image path using the selected class
    # The filenames are in the format "OB-class-Class.jpg"
    imgPath <- paste0("OB-class-", input$class, ".jpg")
    
    # Render the image based on the selected class
    tags$img(src = imgPath, alt = "Class Image", width = "100%")
    
  })
}
