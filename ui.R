library(shiny)
library(DT)

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=MedievalSharp&display=swap');
      body {
        font-family: 'MedievalSharp', cursive;
        background-image: url('parchment.jpg');
        background-size: cover;
        color: #3e2212;
        
      }
      .sidebar-panel-bg {
        background-image: url('parchment.jpg');
        background-size: cover;
        padding: 20px;
        border: 8px groove #deb887; /* Example of a styled border */
        box-shadow: 0px 0px 10px #3e2212; /* Optional shadow for depth */
      }
      .sidebar-panel-bg label,
      .sidebar-panel-bg .shiny-text-output {
        color: #000000; /* White color for labels and outputs */
      }
      .sidebar-panel-bg .form-control {
        color: #000000; /* Black color for input text */
      }
      .skill-list {
        background-color: transparent;
        padding: 10px;
        border-radius: 5px;
      }
      .progress {
        background-color: #b59a68;
        border: 1px solid #8d7a50;
        border-radius: 4px;
        height: 20px;
      }
      .progress-bar {
        background-color: #856404;
      }
      .shiny-input-container {
        margin-bottom: 15px;
      }
      .btn {
        background-color: #8d7a50;
        border-color: #3e2212;
        color: #fff;
        margin-top: 10px;
        font-weight: bold;
      }
      .btn:hover {
        background-color: #3e2212;
      }
      /* Style the DataTable */
      .dataTables_wrapper {
        font-family: 'MedievalSharp', cursive;
        color: #3e2212;
      }
      table.dataTable {
        border-collapse: collapse;
        border-radius: 5px;
        box-shadow: 0 0 10px rgba(0,0,0,0.5);
        border: 8px groove #deb887; /* Example of a styled border */
        box-shadow: 0px 0px 10px #3e2212; /* Optional shadow for depth */
      }
      table.dataTable thead {
        background-color: #8d7a50;
        color: #ffffff;
      }
      table.dataTable thead th {
        font-weight: bold;
      }
      table.dataTable tbody tr {
        background-color: transparent; /* Make table rows transparent */
      }
      table.dataTable tbody td {
        background-color: transparent; /* Make table cells transparent */
      }
      .dataTables_filter input,
      .dataTables_length select {
        color: #3e2212; /* Dark text for DataTable filter and length controls */
      }
      .dataTables_paginate .paginate_button {
        padding: 5px 10px;
        background-color: #8d7a50;
        border: 1px solid #3e2212;
        border-radius: 3px;
        cursor: pointer;
        color: #ffffff; /* White text for pagination buttons */
      }
      .dataTables_paginate .paginate_button:hover {
        background-color: #3e2212;
      }
      /* Hide the default search and entries info to match the theme better */
      .dataTables_filter, .dataTables_info { display: none; }
      /* Additional custom styles */
    "))
  ),
  titlePanel("Character Skill Menu", windowTitle = "Oblivion Skill Tracker"),
  sidebarLayout(
    sidebarPanel(class = "sidebar-panel-bg",
                 textInput("skillName", "Enter Skill Name"),
                 numericInput("lowValue", "Low Value (Novice)", value = 0),
                 numericInput("highValue", "High Value (Master)", value = 100),
                 numericInput("currentLevel", "Current Level", value = 0),
                 tags$hr(style = "border-color: #3e2212;"),
                 actionButton("addSkill", "Add Skill", style = "margin-top: 20px;"),
                 actionButton("updateSkill", "Update Selected Skill", style = "margin-top: 20px;"),
                 actionButton("deleteSkill", "Delete Selected Skill", style = "margin-top: 20px;"),
                 actionButton("saveData", "Save Data", style = "margin-top: 20px;"),
                 tags$hr(style = "border-color: #3e2212;"),
                 selectInput("class", "Choose a Class:",
                             choices = c("Acrobat", "Agent", "Archer", "Assassin", "Barbarian", 
                                         "Bard", "Battlemage", "Crusader", "Healer", "Knight", 
                                         "Mage", "Monk", "Nightblade", "Pilgrim", "Rogue", 
                                         "Scout", "Sorcerer", "Spellsword", "Thief", 
                                         "Warrior", "Witchhunter"),
                             selected = "Nightblade"),
                 uiOutput("classImage")
    ),
    mainPanel(
      div(class = "skill-list",
          DTOutput("skillsTable"),
          uiOutput("dynamicPlot")
      )
    )
  )
)
