#Show people landing page
get '/people' do
    @people = Person.all
    erb :"/people/index"
end

#Shows a new person page
get '/people/new' do
    @person = Person.new
    erb :"/people/new"
end

#Sumit form by creating a new Person object, checks to see if valid data entered and redirect to show page when finished
post '/people' do
  puts params.inspect
  
    if !params[:birthdate].blank? && params[:birthdate].include?("-")
        birthdate = params[:birthdate].gsub("-", "")
    end
    
    @person = Person.new(first_name: params[:first_name], last_name: params[:last_name], birthdate: birthdate)
    if @person.valid?
        @person.save
        redirect "/people/#{@person.id}"
        else
        @person.errors.full_messages.each do |msg|
            @errors = "#{@errors} #{msg}."
        end
        erb :"/people/new"
    end
end

#Shows edit a person page
get '/people/:id/edit' do
    @person = Person.find(params[:id])
    erb :"/people/edit"
end

#Edits individual person and checks to see if valid data is entered and redirect to show the edit
put '/people/:id' do
    @person = Person.find(params[:id])
    @person.first_name = params[:first_name]
    @person.last_name = params[:last_name]
    @person.birthdate = params[:birthdate]
    if @person.valid?
        @person.save
        redirect "/people/#{@person.id}"
        else
        @person.errors.full_messages.each do |msg|
            @errors = "#{@errors} #{msg}."
        end
        erb :"/people/edit"
    end
end

# Delete individual person
delete '/people/:id' do
    person = Person.find(params[:id])
    person.delete
    redirect "/people"
end

# Show individual person page
get '/people/:id' do
    @person = Person.find(params[:id])
    birth_path_num = Person.get_birth_path_num(@person.birthdate.strftime("%m%d%Y"))
    @message = Person.get_message(birth_path_num)
    erb :"/people/show"
end



