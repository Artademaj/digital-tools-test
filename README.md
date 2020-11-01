This work focuses on setting up a recommendation system using "raspberry pi". 
The work consists of two parts. In the first part a recommendation system is created with postgresql 
and in the second part one with python. 

The goal is to create a top 50 list of movies that match my favorite movies 
"Dirty Dancing", "Scarface" or "The Life of David Gale". 

For this project all files are stored in a directory called RS. The recommendations system is based on 
the file moviesFromMetacritic.csv', which contains movie data deleted by a hacker from the metacritic.com website. 

POSTGRESQL

After creating a table and importing the data from the above mentioned file, 
the first step was to see if the file contains the favorite movies. 
Since the movie "The Life of David Gale" could not be found, a next favorite movie was recorded, which is "Iron Man". 
The details regarding installation and checking can be found in the document "1_import_data_commands.sql

RECOMMENDATIONS BASED ON DIRTY DANCING 
-The first thing I tried to do was to get a list of recommendations, 
where in the summary of the other movies they referred to the movie "Dirty Dancing". 
However, I was not satisfied with the results, as only one more film was recommended. 
I don't know the movie "Take the Lead", but after seeing the trailer it is very similar to "Dirty Dancing".
-Afterwards a list was created which should recommend other movies because of the similarity of the titles of other movies. 
It was foreseeable that the second film "Dirty Dancing Havana Nights" would appear. 
Since the recommendation was to be highlighted and no further films were suggested, I was disappointed here too. 
-Next I tried to get a list of films where the same actors as in the leading role are to be seen. 
I was very satisfied with this result, because I like the main actor Patrick Swayze very much. 
However, the content of the proposed films is very different, but as long as you like the main actor, 
this can be a very good recommendations system. 

RECOMMENDATIONS BASED ON SCARFACE
-For my second movie the recommendations were much better based on "summary" then the first movie. 
I had a lot of movies in the list which I have already seen and like (Iron Man, Final Destination, Good night and good luck) 
and are also in the same direction (thriller, drama).
-Since scarface has no other series of films, the recommendation based on titles was not good.
-But the list of recommendations based on Starring was definitely better. 
There the same applies as for Dirty Dancing. I think the main actor is very good and therefore I am satisfied with the outcome.

RECOMMENDATIONS BASED ON IRON MAN
-The list recommendations based on summary was short, but very convincing. 
Of course I had all Iron Man movies in the summary, which made sure that the system was running correctly. 
And then I had three more movies that I wanted to see for a long time.
-Here I was surprised. I got all the movies in the list from the Iron Man series and two more movies suggested, 
which have nothing to do with Iron Man at all. The reason was that both words "iron" and "man" in the title of the 
movies "The Man In The Iron Mask" and "The Man With The Iron Fists" contain. 
Since the recommendations based on titles did not convince me in any of my three favorite movies, 
it is not a good idea to use "Title"  for a recommendar system. 
-Unfortunately I did not receive any results from the evaluation with the main actor. 
The reason for this should be that there are several main actors in the Iron Man movie and the 
other Iron Man movies are constantly changing the main actors. 

PYTHON

Using Python I compared the user reviews and tried to get good recommendations for the movie Scarface. 
I chose Scarface because I got the best recommendations in the first phase with SQL and this movie is probably 
the most famous of all three favorite movies, so there must be a lot of reviews. 
The goal was that every user who rated the film Scarface would be checked to see if that user had seen other films and 
rated them better. The corresponding commands and details are stored in the file "PY-script_recommendar_system.py".
The results can be found in the file "PY_recommendationsBasedOnMetascore.csv. 

Rounded up I must say that I liked the recommendations based on user reviews much more then based on summary, title or starring.
First, I received recommendations which are in the similar genre. 
Second, I got a much higher selection of movies, which allows me to choose between several movies. 
A larger selection means a greater chance to find suitable movies. 
It is also very important to mention the highest ratings for other movies 
actually appealed to me more than the lower ratings from other users.
