class Ability
  include CanCan::Ability

  def initialize(usr)
    if usr
      @user = usr
    else
      @user = User.new
      @user.role = :guest
    end
    send(@user.role)
  end

  def guest
    can :create, User
    can :index, :all
  end

  def user
    can :access, :rails_admin
    can :dashboard
    
    #[index/show]
    can :read, :all

    cannot :show, [Message, Invite]
    can(:show, Message) { |m| m.user_id == @user.id || m.whom_id == @user.id }
    can(:show, Invite) { |i| i.user_id == @user.id || i.whom_id == @user.id }

    can :wall, Album
    can :events, Place

    #[create]
    can :create, [Album, Comment, Event, Invite, Message, Photo, Place, Review]

    #[manage]
    can :manage, [News, Menu], place: { captain: @user.id }

    #[update]
    can [:update, :events], User, id: @user.id
    
    can :update, [Event, Review, Message, Invite], user_id: @user.id
    can :update, Place, user_id: @user.id, status: 'draft'
    can :update, Place, captain: @user.id

    can :destroy, User, id: @user.id
    can :destroy, Event, user_id: @user.id, member_ids: []
    can :destroy, [Service, Review, Message, Invite, Photo], user_id: @user.id
    can :destroy, Message, whom_id: @user.id
    
    #[action]
    can [:join, :unjoin], Event
    can [:accept, :refuse], Invite, whom_id: @user.id
  end

  def moderator
    user
    can :access, :rails_admin
    can :dashboard
    can :manage, [Comment, Review]
  end

  def admin
    can :manage, :all # cannot manage roles
    cannot(:destroy, User) { |u| u.role == 'admin' || u.role == 'lord' }
  end

  def lord
    can :manage, :all # include manage roles
  end
end