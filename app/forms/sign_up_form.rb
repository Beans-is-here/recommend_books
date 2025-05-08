class SignUpForm
    include ActiveModel::Model
    include ActiveModel::Attributes
    attribute :email, :string
    attribute :password, :string
    attribute :password_confirmation, :string
    attribute :name, :string
  
  
  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      user.save!
    end
rescue StandardError => e
    Rails.logger.error "Save failed: #{e.message}"
    false
  end

    def user
      @user ||= User.new(name: name, email: email, password: password, password_confirmation: password_confirmation)
    end
  
    private
  
    def email_is_not_taken_by_another
      errors.add(:email, :taken, value: email) if User.exists?(email: email)
    end
  
    def github_account_exists
      require 'net/http'
      if name.present? && !github_user_exists?(name)
        errors.add(:name, "GitHubに存在するユーザー名しか登録できません")
      end
    end
  
    def github_user_exists?(username)
      response = Net::HTTP.get_response(URI("https://github.com/#{username}"))
      if response.code == '200' 
        return true
      else
        return false
      end
    end
  end
  
  