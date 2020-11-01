import pandas as pd

#data is a dataframe
data = pd.read_csv('userReviews.csv', sep=';')

#the same as SELECT function in SQL
print(data.head())
print(data[:3])
print(data.movieName.iloc[1])


#create an empty new dataframe
#insert all authors review in the datafram and only if it was for the movie "beach-rats"
subset = data[data.movieName == 'scarface']

#overview of the authors whom review the movie
print(subset)

#Create final dataframe for the recommendations that also include the relative score
recommendations = pd.DataFrame(columns=data.columns.tolist()+['rel_inc'])

#loop over all Authors that watched the same favorit movie and then save each author who gave a ranking for the favorit movie
for idx, Author in subset.iterrows():
    author = Author[['Author']].iloc[0]
    ranking = Author[['Metascore_w']].iloc[0]
    filter1 = (data.Author==author)
    filter2 = (data.Metascore_w>ranking)
    possible_recommendations = data[filter1 & filter2]
    print(possible_recommendations.head())
    possible_recommendations.loc[:,'rel_inc'] = possible_recommendations.Metascore_w/ranking
    recommendations = recommendations.append(possible_recommendations)
    
    
recommendations = recommendations.sort_values(['rel_inc'], ascending=False)
    
recommendations = recommendations.drop_duplicates(subset='movieName', keep="first")

recommendations.head(50).to_csv("PY_recommendationsBasedOnMetascore.csv", sep=";", index=False)
print(recommendations.head(50))

