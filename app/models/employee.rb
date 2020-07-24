# frozen_string_literal: true

class Employee < ApplicationRecord
  def self.populate2
    datafile = File.read(Rails.root.join('docs', 'employee_array.txt'))
    p_bar = ProgressBar.create(title: 'EMPLOYEE', starting_at: 0, total: datafile.each_line.count, format: ' %P%: %e (%c/%C): %t')
    counter = 1
    batch = []

    datafile.each_line do |line|
      line = line.gsub('\r\n', '')
      line = line.gsub('"', '')

      begin
        line_array = line.encode('UTF-8', invalid: :replace).split(',')
      rescue StandardError
        line_array = []
        puts '### parse error ###'
        puts line
      end

      record = {

        surname: line_array[0].to_s,
        first_name: line_array[1].to_s,
        address: line_array[2].to_s,
        emails: line_array[3].to_s,
        created_at: Time.now,
        updated_at: Time.now
      }

      batch << record

      # when batch size is multiple of 30, save it to DB
      if counter % 30 == 0
        # byebug
        begin
          Rails.logger do
            logger.debug 'Showing batch: ' + @batch
            result = Employee.insert_all!(batch)
          end
          batch = []
        rescue StandardError
          puts '### save error ###'
          puts result
          batch = []
        end
      end

      counter += 1
      p_bar.increment
    end # each_line

    # save last batch
    begin
      Rails.logger do
        result = Employee.insert_all!(batch)
      end
    rescue StandardError
      puts '### save error ###'
      puts result
    end
    puts 'Employee total records:'
    puts Employee.count
  end
end
