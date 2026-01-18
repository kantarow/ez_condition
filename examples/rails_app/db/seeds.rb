# frozen_string_literal: true

# Clear existing data
puts 'Clearing existing data...'
AccessRule.destroy_all
Resource.destroy_all
User.destroy_all

# Create users
puts 'Creating users...'
admin = User.create!(
  name: 'Admin User',
  email: 'admin@example.com',
  role: 'admin',
  department: 'engineering',
  age: 35,
  active: true
)

manager = User.create!(
  name: 'Manager User',
  email: 'manager@example.com',
  role: 'manager',
  department: 'engineering',
  age: 30,
  active: true
)

member = User.create!(
  name: 'Member User',
  email: 'member@example.com',
  role: 'member',
  department: 'sales',
  age: 25,
  active: true
)

hr_member = User.create!(
  name: 'HR Member',
  email: 'hr@example.com',
  role: 'member',
  department: 'hr',
  age: 28,
  active: true
)

puts "Created #{User.count} users"

# Create resources
puts 'Creating resources...'
salary_report = Resource.create!(
  name: 'Salary Report',
  description: 'Monthly salary report containing sensitive employee compensation data',
  resource_type: 'report'
)

engineering_docs = Resource.create!(
  name: 'Engineering Documentation',
  description: 'Technical documentation and system architecture',
  resource_type: 'document'
)

hr_system = Resource.create!(
  name: 'HR Management System',
  description: 'Human resources management system access',
  resource_type: 'system'
)

puts "Created #{Resource.count} resources"

# Create access rules
puts 'Creating access rules...'

# Salary Report - Admin only
AccessRule.create!(
  resource: salary_report,
  name: 'Admin Only Read',
  action: 'read',
  condition: {
    'type' => 'equal',
    'left' => { 'type' => 'var', 'name' => 'role' },
    'right' => { 'type' => 'string', 'value' => 'admin' }
  }
)

# Salary Report - Engineering Manager can also read
AccessRule.create!(
  resource: salary_report,
  name: 'Engineering Manager Read',
  action: 'read',
  condition: {
    'type' => 'and',
    'left' => {
      'type' => 'equal',
      'left' => { 'type' => 'var', 'name' => 'department' },
      'right' => { 'type' => 'string', 'value' => 'engineering' }
    },
    'right' => {
      'type' => 'equal',
      'left' => { 'type' => 'var', 'name' => 'role' },
      'right' => { 'type' => 'string', 'value' => 'manager' }
    }
  }
)

# Engineering Docs - Engineering department only
AccessRule.create!(
  resource: engineering_docs,
  name: 'Engineering Department Only',
  action: 'read',
  condition: {
    'type' => 'equal',
    'left' => { 'type' => 'var', 'name' => 'department' },
    'right' => { 'type' => 'string', 'value' => 'engineering' }
  }
)

# HR System - Admin OR active HR members
AccessRule.create!(
  resource: hr_system,
  name: 'Admin or Active HR Members',
  action: 'read',
  condition: {
    'type' => 'or',
    'left' => {
      'type' => 'equal',
      'left' => { 'type' => 'var', 'name' => 'role' },
      'right' => { 'type' => 'string', 'value' => 'admin' }
    },
    'right' => {
      'type' => 'and',
      'left' => {
        'type' => 'equal',
        'left' => { 'type' => 'var', 'name' => 'department' },
        'right' => { 'type' => 'string', 'value' => 'hr' }
      },
      'right' => {
        'type' => 'equal',
        'left' => { 'type' => 'var', 'name' => 'active' },
        'right' => { 'type' => 'boolean', 'value' => 'true' }
      }
    }
  }
)

puts "Created #{AccessRule.count} access rules"

puts "\nSeed data created successfully!"
puts "\nTest scenarios:"
puts "1. Admin user can access all resources"
puts "2. Manager (engineering) can access Salary Report and Engineering Docs"
puts "3. Member (sales) cannot access any resources"
puts "4. HR Member can access HR System only"
