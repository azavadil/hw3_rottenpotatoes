# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!( movie )
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  #flunk
  regexp = /#{e1}.*#{e2}/m
  page.body.should =~ regexp
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"


When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.gsub!(","," ").split.each do |rating|
    if uncheck
      step %Q{I uncheck "ratings_#{rating}"}
    else
      step %Q{I check "ratings_#{rating}"}
    end
  end
end

When /^I should see movies with the following ratings: (.*)/ do |rating_list|
  ##puts rating_list
  ##puts rating_list.split(",")
  Movie.find_all_by_rating( rating_list.gsub!(","," ").split ).each do |movie|
    step %Q{I should see "#{movie.title}"}
  end
end

When /^I should not see movies with the following ratings: (.*)/ do |rating_list|
  Movie.find_all_by_rating( rating_list.gsub!(","," ").split ).each do |movie|
    step %Q{I should not see "#{movie.title}"}
  end
end

When /^I check all of the ratings/ do
  Movie.all_ratings.each do |rating|
    check("ratings_#{rating}")
  end
end

When /^I uncheck all of the ratings/ do
  Movie.all_ratings.each do |rating|
    uncheck("ratings_#{rating}")

    ## alternative: call web_steps
    #step %Q{I uncheck "ratings_#{rating}"}
  end
end


When /^I should see all of the movies/ do
  ## Count the number of rows in the table.
  ## e.g. rows.should == value

  movie_count = Movie.all.count
  rows = page.all('table#movies tr').count
  rows.should == movie_count+1  ## +1 to account for headers
end

When /^I should see 5 movies/ do
  rows = page.all('table#movies tr').count
  rows.should == 7
end

