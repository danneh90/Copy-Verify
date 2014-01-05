def usage 
  if ARGV[0] == nil || ARGV[0] == 'help'
    puts "Usage:"
    puts "3 arguments - Folder 1, Folder 2 and number of files to check"
    puts "ruby copy-verify.rb /Users/Dan/Desktop/1 /Users/Dan/Desktop/2 50"
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
  end
  
  if (files_in_a - files_in_b).count > 0
    puts "Files in folder B that are not in folder A"
    puts files_in_b - files_in_a
  end

end

usage

# Get arguments
source_d = Dir.pwd
source_d = "/Users/Dan/Desktop/1"
source_d = ARGV[0]
destin_d = "/Users/Dan/Desktop/2"
destin_d = ARGV[1]
number_to_check = ARGV[2].to_i

puts "Scanning Folders ..."
Dir.chdir(source_d)
files_a = Dir.glob("**/*").reject { |file_path| File.directory? file_path }
Dir.chdir(destin_d)
files_b = Dir.glob("**/*").reject { |file_path| File.directory? file_path }

puts "Comparing File Trees ..."
count_and_compare(files_a, files_b)

if number_to_check > 0 
  puts "Checking #{number_to_check} Random Files"
  randommd5(files_a, source_d, destin_d, number_to_check)
end 
