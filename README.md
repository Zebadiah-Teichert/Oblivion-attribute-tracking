Oblivion Skill Tracker

Track your personal skills with a fantasy "Oblivion" theme!

Features

Add, Update, and Delete Skills: Manage your skills with ease.
Visualize Progress: View skill levels and their normalized values.
Class Imagery: Choose and view images of fantasy classes.
Save and Load Data: Keep track of your progress with CSV file support.
Getting Started

Clone the Repo:
Copy code
git clone https://github.com/YourUsername/Oblivion-attribute-tracking.git

Install Packages:
r
Copy code
install.packages(c("shiny", "DT", "ggplot2", "showtext"))
Run the App:
r
Copy code
shiny::runApp()


How It Works

Normalization: Skill levels are scaled from 0 to 100 using the formula:

Add Skills: Enter skill details and click "Add Skill".
Update Skills: Select a skill and click "Update Selected Skill".
Delete Skills: Select a skill and click "Delete Selected Skill".
Save Data: Click "Save Data" to export to CSV.
License

MIT License. See LICENSE for details.

