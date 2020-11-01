import pandas as pd

#data is a dataframe
data = pd.read_csv('userReviews.csv', sep=';')

#the same as SELECT function in SQL
print(data.head())
print(data[:3])
print(data.movieName.iloc[1])

#give the df a conent: insert all authors review in the datafram and only if it was for the movie scarface
subset = data[data.movieName == 'scarface']

#overview of the authors which reviewed the movie scarface
print(subset)

#Create final dataframe for the recommendations that also includes the relative score
recommendations = pd.DataFrame(columns=data.columns.tolist()+['rel_inc'])

#loop over all Authors that watched the same favorit movie and 
for idx, Author in subset.iterrows():
    #save each author and ranking who reviews scarface 
    author = Author[['Author']].iloc[0]
    ranking = Author[['Metascore_w']].iloc[0]
    
    #create a new df "possible recommendations" with all movies which were ranked by the selected author
    filter1 = (data.Author==author)
    filter2 = (data.Metascore_w>ranking)
    possible_recommendations = data[filter1 & filter2]
    
    #and calculate the relative increase
    possible_recommendations.loc[:,'rel_inc'] = possible_recommendations.Metascore_w/ranking
    
    #change the possilbe recommendations df to our new recommendations df
    recommendations = recommendations.append(possible_recommendations)
    
#sort the recommendations where the highest relative increases are on top
recommendations = recommendations.sort_values(['rel_inc'], ascending=False)

#drop duplicates to decrease the size of the file
recommendations = recommendations.drop_duplicates(subset='movieName', keep="first")

#check the outcome first, if the recommendations make sense - is working
print(recommendations.head(50))

#creating a csv file with the recommendations / results 
recommendations.head(50).to_csv("PY_recommendationsBasedOnMetascore.csv", sep=";", index=False)


