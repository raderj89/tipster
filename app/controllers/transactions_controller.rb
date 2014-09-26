class TransactionsController < ApplicationController

  before_action :set_property, except: [:show, :review, :confirm]
  before_action :signed_in_user
  before_action :correct_user
  before_action :set_transaction, except: [:new, :create]

  def new
    @transaction = current_user.transactions.new
    @transaction.employee_tips.build
  end

  def create
    @transaction = current_user.transactions.new(transaction_params)
    if @transaction.save
      flash[:success] = "Please review your order."
      redirect_to review_user_property_transaction_path(current_user, @property, @transaction)
    else
      flash[:error] = "There was a problem sending out your tips."
      render :new
    end
  end

  def review
  end

  def confirm
    if @transaction.pay
      TransactionMailer.user_transaction(current_user).deliver
      flash[:success] = "You have successfully sent out tips!"
      redirect_to current_user
    else
      flash[:error] = "There was a problem sending out your tips. Please try again."
      render :review
    end
  end

  def show
  end

  private

    def set_property
      @property = Property.find(params[:property_id])
    end

    def set_transaction
      @transaction = Transaction.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to current_user, notice: "We couldn't find that page"
    end

    def correct_user
      @user = User.find(params[:user_id])
      redirect_to root_path unless current_user?(@user)
    end

    def transaction_params
      params.require(:transaction).permit(:property_id, employee_tips_attributes: [:employee_id, :amount, :message])
    end
end
