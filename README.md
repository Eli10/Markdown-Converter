# Basic Idea

The basic idea of this program is to convert a typically markdown file into an HTML file.
The way that I plan on implementing it is going to be similar to our latest homework assignment
in which we had to parse through a Makefile and convert the target lines in a graph of
dependencies. I plan on scanning through the whole markdown file line by line, classifying each
line with an outer classification of either header, body text or list which are the main “data
structures” within a markdown file.
For the lines classified as header, there will be another function run on those lines to
determine the level of the header needed to be applied. For example, if the line has 5 pound
signs then the equivalent header tags needed to be applied on that line will be <h5></h5>. For
the lines classified as body text, they will also be reiterated in order to figure out if any strings
needed additional styling such as bold, italics or quotes. Similar for lists, we have to figure out
what kind of list are these lines trying to make with the options being ordered or unordered lists.
Each Markdown “data structure” will have a one to one pairing to a HTML tag. All of
these pairing will be held in a Map that I can reference as the program goes through each line
and the contents of them. Regular Expression will be of heavy use as i will need to replace
markdown keys with the proper HTML tags to the beginning and ending of lines and string. That
might be the hardest part of the program to implement. I may need to use regex libraries to
make the implementation an easier process.


# Testing

Testing my implementation against some other "canonical" Markdown implementation
- Either against CommonMark or a version of Markdown


# Compile

ocamlopt -o ex str.cmxa main.ml
./ex
