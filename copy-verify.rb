def usage 
  if ARGV[0] == nil || ARGV[0] == 'help'
    puts "Usage:"
    puts "4 arguments - Folder 1, Folder 2, number of files to check, include_hidden_files"
    puts "ruby copy-verify.rb /Users/Dan/Desktop/1 /Users/Dan/Desktop/2 50 false"
    puts "warning: an MD5 check will be calculated for the checked files, this may take a while"
    exit
  end
end

def randommd5 file_list, folder_a, folder_b, number_to_check
  array_of_bad_files = Array.new
  i = 0
  for i in 0...number_to_check do
    filename = file_list.sample
    puts "#{i}: #{filename}"
  
    sourcemd = `md5 \"#{folder_a}/#{filename}\"`
    smd = sourcemd.slice(-33..-2)
    puts "\t#{smd} Source MD5"
  

    destmd = `md5 \"#{folder_b}/#{filename}\"`
    dmd = destmd.slice(-33..-2)
    puts "\t#{dmd} Destination MD5"
  
    if dmd.eql?(smd)
      puts "\e[32mFile is ok\e[0m\n\n"
    else
      puts "\e[31mError with file \e[0m\a\n\n"
      array_of_bad_files << filename
    end
  
    i = i + 1
  end

  array_of_bad_files.each do |badfile|
    puts "#{badfile} Is Corrupt"
  end
end

def count_and_compare files_in_a, files_in_b
  
  if (files_in_a - files_in_b).count > 0
    puts "Files in folder A that are not in folder B"
    puts files_in_a - files_in_b
    leftina = files_in_a - files_in_b
    leftina.each do |file|
      file_path = "#{ARGV[0]}/#{file}" 
      puts "#{file_path} = #{File.size(file_path)}"
    end
  end
  
  if (files_in_a - files_in_b).count > 0
    puts "Files in folder B that are not in folder A"
    puts files_in_b - files_in_a
  end

  return files_in_a - (files_in_a - files_in_b)
end

def compare_filesize files_in_both, source_d, destin_d
  
  inequal_files = Array.new
  equal_files = Array.new
  
  files_in_both.each do |file|
    file_path = "#{source_d}/#{file}"
    size_in_a = File.size("#{source_d}/#{file}")
    size_in_b = File.size("#{destin_d}/#{file}")
    if(size_in_a != size_in_b)
      inequal_files << [file, size_in_a, size_in_b]
    else
      equal_files << [file, size_in_a, size_in_b]
    end
  end
  
  puts "#{equal_files.count} equal files,\n#{inequal_files.count} Unequal files are:"
  puts inequal_files
end

usage

# Get arguments
source_d = Dir.pwd
source_d = "/Users/Dan/Desktop/1"
source_d = ARGV[0]
destin_d = "/Users/Dan/Desktop/2"
destin_d = ARGV[1]
number_to_check = ARGV[2].to_i
include_hidden_files = ARGV[3].eql?('true') ? true : false

puts "Scanning Folders ..."
Dir.chdir(source_d)
scan_term = include_hidden_files ? "**/{*,.*}" : "**/*"
files_a = Dir.glob(scan_term).reject { |file_path| File.directory? file_path }
Dir.chdir(destin_d)
files_b = Dir.glob(scan_term).reject { |file_path| File.directory? file_path }

puts "Comparing File Trees ..."
files_in_both = count_and_compare(files_a, files_b)

compare_filesize(files_in_both, source_d, destin_d)

if number_to_check > 0 
  puts "Checking #{number_to_check} Random Files"
  randommd5(files_a, source_d, destin_d, number_to_check)
end 
