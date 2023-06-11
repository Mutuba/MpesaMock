# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_230_611_063_954) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'mpesa_accounts', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.decimal 'available_balance', precision: 8, scale: 2, default: '0.0', null: false
    t.uuid 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_mpesa_accounts_on_user_id'
  end

  create_table 'mpesa_transactions', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.decimal 'amount', precision: 8, scale: 2, default: '0.0', null: false
    t.boolean 'complete', default: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.uuid 'sender_id'
    t.uuid 'receiver_id'
    t.string 'transaction_code'
    t.index ['receiver_id'], name: 'index_mpesa_transactions_on_receiver_id'
    t.index ['sender_id'], name: 'index_mpesa_transactions_on_sender_id'
  end

  create_table 'notifications', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'recipient_type', null: false
    t.uuid 'recipient_id', null: false
    t.string 'type', null: false
    t.jsonb 'params'
    t.datetime 'read_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['read_at'], name: 'index_notifications_on_read_at'
    t.index %w[recipient_type recipient_id], name: 'index_notifications_on_recipient'
  end

  create_table 'pg_search_documents', force: :cascade do |t|
    t.text 'content'
    t.string 'searchable_type'
    t.bigint 'searchable_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[searchable_type searchable_id], name: 'index_pg_search_documents_on_searchable'
  end

  create_table 'users', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'first_name'
    t.string 'last_name'
    t.string 'phone_number', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'mpesa_accounts', 'users'
  add_foreign_key 'mpesa_transactions', 'users', column: 'receiver_id'
  add_foreign_key 'mpesa_transactions', 'users', column: 'sender_id'
end
