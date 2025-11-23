**Pokémon Data Analysis Project**

- Only includes the Pokémon from the first 7 Generations (Not including megas, ultra beasts, and different forms)

Data gotten from https://www.kaggle.com/datasets/rounakbanik/pokemon


**Project Process**

1. Clean the Data in Excel to get rid of non-needed data  
	a. Got rid of Japanese Names  
	b. Cleaned name so there are no symbols for male and female (This is needed so the data can be used in MySQL (They don't like special characters))  

2. Imported to SQL for more Data Cleaning  
   a. Removed Duplicates  
   b. Standardized the Data  
   c. Null Values or Blank values  
   d. Removed Any Columns  
   e. Reordered Columns (Better readability)  

3. Data Exploratory Analysis and Visualization in Tableau
   a. Created a Dashboard that shows all the average stats for each type
		- Dragon type has the highest stats based on total stats, but Dragon is always in the top 3 in every other stat
		- Bug is the lowest total stat and seems to be at the bottom of most graphs
