# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
# New spellings on a monday
# Tests on Mondays
#
week1 = Week.find_or_create_by!(date: Date.new(2024,11,18), note: "'oh' sounds")

Word.find_or_create_by!(title: "Sew", week: week1)
Word.find_or_create_by!(title: "Pharaoh", week: week1)
Word.find_or_create_by!(title: "Goes", week: week1)
Word.find_or_create_by!(title: "Folk", week: week1)
Word.find_or_create_by!(title: "Although", week: week1)

week2 = Week.find_or_create_by!(date: Date.new(2024,11,25), note: "test")

Word.find_or_create_by!(title: "Friend", week: week2)
Word.find_or_create_by!(title: "Said", week: week2)
Word.find_or_create_by!(title: "Any", week: week2)
Word.find_or_create_by!(title: "Leopard", week: week2)
Word.find_or_create_by!(title: "February", week: week2)

week3 = Week.find_or_create_by!(date: Date.new(2025,1,6), note: "'b' as in baby")

Word.find_or_create_by!(title: "Build", week: week3)
Word.find_or_create_by!(title: "Bottle", week: week3)
Word.find_or_create_by!(title: "Bridge", week: week3)
Word.find_or_create_by!(title: "Cupboard", week: week3)
Word.find_or_create_by!(title: "February", week: week3)

user = User.find_by(email_address: "you@example.org")
User.create! email_address: "you@example.org", password: "s3cr3t", password_confirmation: "s3cr3t", username: "testing" unless user
