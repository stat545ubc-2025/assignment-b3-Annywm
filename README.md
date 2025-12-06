## BC Farms GHG Emission Dashboard

This Shiny app analyzes Greenhouse Gas (GHG) Emissions from various crop types in BC farms using data from the Litefarm database.

### Features

There are three main features of this app:

- **FEATURE 1:** A dynamic **Density Plot** showing the distribution of Total GHG emissions (CO2e/ha) faceted by crop type. 
This plot updates based on the **Crop Types** selected by the user in the sidebar "Control Panel".

- **FEATURE 2:** A **Summary Statistics Table** showing the Mean, Median, Minimum, and Maximum GHG emissions for the selected crops. 
This table updates dynamically with the user's crop selection and includes a sorting function (controlled by a checkbox) to order results by Mean value.

- **FEATURE 3:** A **Data Download** feature. Users can export the generated summary statistics table as a `.csv` file by clicking the "Download Summary Table" button in the sidebar.

### View the App

You can test out the app for yourself at: [link_to_shinyapp.io][https://annywm.shinyapps.io/ResearchProjects/]
