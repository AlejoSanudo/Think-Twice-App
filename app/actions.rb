# Homepage (Root path)
helpers do
  def current_user
    @user = User.find(session[:user_id]) if session[:user_id]
  end

  #for enumerables
  def make_error_message(errors)
    message = "Some issues: "
      if errors.is_a?(Array)
        message << errors.join(", ") << "."
      else
        message << errors.full_messages.join(", ") <<"."
      end
  end
end

get '/', '/index', '/home','/main' do
  erb :'home'
end

get '/login' do
  @user = User.find(1)
  session[:user_id] = @user.id
  redirect :'home'
end

get '/logout' do
  @user = nil
  session.clear
  redirect :'home'
end

get '/expenses' do
  @expenses = Expense.where(user_id: current_user.id) if current_user
  erb :expenses
end

post '/expenses/add' do
  @expense = Expense.new(
    user_id: current_user.id,
    name: params[:name],
    value: params[:value].to_f,
    interval: params[:interval]
  )

  if @expense.save
    flash[:success] = "#{@expense.name} added!"
  else
    flash[:errors] = make_error_message(@expense.errors)
  end
  
  redirect '/expenses'
end

post '/expenses/delete/:id' do
  Expense.find(params[:id]).destroy
  redirect '/expenses'
end

post '/think-twice/' do
  @expenses = Expense.where(user_id: current_user.id) if current_user
  if params[:amount].to_f > 0
    @tt = params[:amount]
    erb :'/results'
  else
    flash[:errors] = "Sorry but we need a number greater than 0..."
    redirect '/'
  end
end