require 'bcrypt'

class User < ApplicationRecord
    include BCrypt
    attr_accessor :password

    has_many :twits

    EMAIL_REGEX = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
    validates :name, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
    validates :password, :confirmation => true #password_confirmation attr
    validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
    validates_length_of :password, :in => 6..20, :on => :create

    def enc_password
        @encrypt_password ||= Password.new(encrypted_password)
    end
    
    def enc_password=(new_password)
        @encrypt_password = Password.create(new_password)
        self.encrypted_password = @encrypt_password
    end
end
