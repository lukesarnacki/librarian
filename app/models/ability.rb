class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
      can :access, :rails_admin
    else
      can :read, Book
      can :reserve, Book
    end
  end
end
