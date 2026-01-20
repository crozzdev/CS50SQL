# 36 Views

In this exercise, you will be working with a database containing information about Japanese woodblock prints from two famous artists: Katsushika Hokusai and Utagawa Hiroshige. The database is stored in a file called views.db.

## Schema

In views.db you’ll find a single table, views. In the views table, you’ll find the following columns:

id, which uniquely identifies each row (print) in the table
print_number, which identifies the number of the print in either Hokusai’s or Hiroshige’s series
english_title, which is the English title of the print
japanese_title, which is the Japanese title of the print
artist, which is the last name of the print’s artist
average_color, which is the hexadecimal representation of the color found by averaging the colors of each pixel in the image
brightness, which is a number corresponding to the overall lightness or darkness of the image
contrast, which is a number representing the extent of the difference between light and dark areas of the image
entropy, which is a measure used to quantify the complexity of the artwork

## Specification

For each of the following questions, you should write a single SQL query that outputs the results specified by each problem. Your response must take the form of a single SQL query. You should not assume anything about the ids of any particular observations: your queries should be accurate even if the id of any particular observation were different. Finally, each query should return only the data necessary to answer the question.

In 1.sql, write a SQL query that a translator might take interest in: list, side by side, the Japanese title and the English title for each print. Ensure the Japanese title is the first column, followed by the English title.
In 2.sql, write a SQL query to list the average colors of prints by Hokusai that include “river” in the English title. (As an aside, do they have any hint of blue?)
In 3.sql, write a SQL query to count how many prints by Hokusai include “Fuji” in the English title. Though all of Hokusai’s prints focused on Mt. Fuji, in how many did “Fuji” make it into the title?
In 4.sql, write a SQL query to count how many prints by Hiroshige have English titles that refer to the “Eastern Capital”. Hiroshige’s prints were created in Japan’s “Edo period,” referencing the eastern capital city of Edo, now Tokyo.
In 5.sql, write a SQL query to find the highest contrast value of prints by Hokusai. Name the column “Maximum Contrast”. Does Hokusai’s prints most contrasting print actually have much contrast?
In 6.sql, write a SQL query to find the average entropy of prints by Hiroshige, rounded to two decimal places. Call the resulting column “Hiroshige Average Entropy”.
In 7.sql, write a SQL query to list the English titles of the 5 brightest prints by Hiroshige, from most to least bright. Compare them to this list on Wikipedia to see if your results match the print’s aesthetics.
In 8.sql, write a SQL query to list the English titles of the 5 prints with the least contrast by Hokusai, from least to highest contrast. Compare them to this list on Wikipedia to see if your results match the print’s aesthetics.
In 9.sql, write a SQL query to find the English title and artist of the print with the highest brightness.
In 10.sql, write a SQL query to answer a question of your choice about the prints. The query should:
Make use of AS to rename a column
Involve at least one condition, using WHERE
Sort by at least one column, using ORDER BY
