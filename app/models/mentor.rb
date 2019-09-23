class Mentor < ApplicationRecord
    enum category: [:lecturer, :mentor]
end
