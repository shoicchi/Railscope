# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_190_826_224_658) do
  create_table 'active_admin_comments', force: :cascade do |t|
    t.string 'namespace'
    t.text 'body'
    t.string 'resource_type'
    t.integer 'resource_id'
    t.string 'author_type'
    t.integer 'author_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[author_type author_id], name: 'index_active_admin_comments_on_author_type_and_author_id'
    t.index ['namespace'], name: 'index_active_admin_comments_on_namespace'
    t.index %w[resource_type resource_id], name: 'index_active_admin_comments_on_resource_type_and_resource_id'
  end

  create_table 'admin_users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_admin_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_admin_users_on_reset_password_token', unique: true
  end

  create_table 'bookmarks', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.integer 'note_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['note_id'], name: 'index_bookmarks_on_note_id'
    t.index ['user_id'], name: 'index_bookmarks_on_user_id'
  end

  create_table 'hashtags', force: :cascade do |t|
    t.string 'tag_name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['tag_name'], name: 'index_hashtags_on_tag_name', unique: true
  end

  create_table 'likes', force: :cascade do |t|
    t.integer 'note_id', null: false
    t.integer 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['note_id'], name: 'index_likes_on_note_id'
    t.index ['user_id'], name: 'index_likes_on_user_id'
  end

  create_table 'my_notes', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.integer 'note_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['note_id'], name: 'index_my_notes_on_note_id'
    t.index ['user_id'], name: 'index_my_notes_on_user_id'
  end

  create_table 'note_hashtags', force: :cascade do |t|
    t.integer 'note_id', null: false
    t.integer 'hashtag_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['hashtag_id'], name: 'index_note_hashtags_on_hashtag_id'
    t.index ['note_id'], name: 'index_note_hashtags_on_note_id'
  end

  create_table 'notes', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.string 'title', null: false
    t.string 'overview', null: false
    t.text 'content', null: false
    t.integer 'is_browsable_guest', default: 1, null: false
    t.integer 'view_point', default: 0, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_notes_on_user_id'
  end

  create_table 'points', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.integer 'reason', null: false
    t.integer 'point', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_points_on_user_id'
  end

  create_table 'postscripts', force: :cascade do |t|
    t.integer 'review_id', null: false
    t.integer 'note_id', null: false
    t.text 'postscript', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['note_id'], name: 'index_postscripts_on_note_id'
    t.index ['review_id'], name: 'index_postscripts_on_review_id'
  end

  create_table 'reviews', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.integer 'note_id', null: false
    t.float 'quality', null: false
    t.text 'review'
    t.integer 'is_appending', default: 0, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['note_id'], name: 'index_reviews_on_note_id'
    t.index ['user_id'], name: 'index_reviews_on_user_id'
  end

  create_table 'subscriptions', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.string 'payjp_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_subscriptions_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string 'current_sign_in_ip'
    t.string 'last_sign_in_ip'
    t.string 'name'
    t.text 'profile'
    t.integer 'grade', default: 0, null: false
    t.string 'provider', default: '', null: false
    t.string 'uid', default: '', null: false
    t.string 'payjp_id'
    t.integer 'is_member', default: 0, null: false
    t.integer 'holding_point', default: 0, null: false
    t.integer 'is_delivery', default: 1, null: false
    t.integer 'phone_number'
    t.integer 'is_deleted', default: 0, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['name'], name: 'index_users_on_name', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
    t.index %w[uid provider], name: 'index_users_on_uid_and_provider', unique: true
  end
end
