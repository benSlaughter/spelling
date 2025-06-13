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
weeks = [
    {
        date: Date.new(2024, 11, 18),
        note: "'oh' sounds",
        words: %w[Sew Pharaoh Goes Folk Although]
    },
    {
        date: Date.new(2024, 11, 25),
        note: "",
        words: %w[Friend Said Any Leopard February]
    },
    {
        date: Date.new(2025, 1, 6),
        note: "'b' as in baby",
        words: %w[Build Bottle Bridge Cupboard February]
    },
    {
        date: Date.new(2025, 1, 13),
        note: "M",
        words: %w[Diaphragm Bomb Column Machine Imagine]
    },
    {
        date: Date.new(2025, 1, 20),
        note: "Q and Qw",
        words: %w[Quickly Question Quarter Weigh Awkward]
    },
    {
        date: Date.new(2025, 1, 27),
        note: "P",
        words: %w[Piece Appear Popular Opposite Poured]
    },
    {
        date: Date.new(2025, 2, 3),
        note: "J",
        words: %w[Bridge Trudge Soldier Suggest Change]
    },
    {
        date: Date.new(2025, 2, 10),
        note: "Ch",
        words: %w[Picture Creature Ancient Children Clutch]
    },
    {
        date: Date.new(2025, 2, 24),
        note: "Oy",
        words: %w[Enjoyed Lawyer Loyal Voice Noisy]
    },
    {
        date: Date.new(2025, 3, 3),
        note: "Ooh",
        words: %w[Two Too To Through Threw Blue Illusion]
    },
    {
        date: Date.new(2025, 3, 10),
        note: "oo",
        words: %w[Understood Shook Push Pudding Woman]
    },
    {
        date: Date.new(2025, 3, 17),
        note: "ear",
        words: %w[Here Hear Disappear Engineer Cereal Sincere]
    }
]

weeks.each do |week_attr|
    week = Week.find_or_create_by!(date: week_attr[:date], note: week_attr[:date])
    week_attr[:words].each do |word|
        Word.find_or_create_by!(title: word, week: week)
    end

    week.create_wordsearch
end

fake_creds = {
    password: "s3cr3tPD",
    password_confirmation: "s3cr3tPW"
}

# Create a student
student = User.find_by(username: "Student")
Student.create!(username: "Student", email_address: "student@example.org", **fake_creds) unless student
# Create a teacher
teacher = User.find_by(username: "Teacher")
Teacher.create!(username: "Teacher", email_address: "teacher@example.org", **fake_creds) unless teacher
# Create an admin
user = User.find_by(username: "testing")
Admin.create!(username: "testing", email_address: "admin@example.org", **fake_creds) unless user
