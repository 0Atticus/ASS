require 'w3c_validators'
  
include W3CValidators

@validator = CSSValidator.new

class String
    def is_num?
        true if Float(self) rescue false
    end
end
class Integer
  def is_num?
    true
  end
end
class Array
  def is_num?
    false
  end
end



def parse_loops(input, vars)

    loop_cap = false
    iterator = nil
    replace_var = nil
    loop_content = ""
    output = ""
    loop_depth = 0
  





    input.split("\n").each do |line|


        if loop_cap
            if line == "end"
                loop_depth -= 1
                if loop_depth == 0

                    vars.each do |key, val|
                        if iterator == key
                            iterator = val
                        end
                    end
                    if iterator.is_num?
                        i = 1
                        until i > iterator.to_i
                            output << "#{loop_content.gsub("!#{replace_var}", "#{i}")}\n"
                            i += 1
                        end 

                        loop_cap = false
                        iterator = nil
                        replace_var = nil
                        loop_content = ""
                    
                    elsif iterator.is_a? Array
                        iterator.each do |i|
                            output << "#{loop_content.gsub("!#{replace_var}", "#{i}")}\n"
                        end

                    end
                end
            end
            if line == "end" && loop_cap == false
            
            elsif line != ""
                loop_content << "#{line}\n"
            end
        elsif !line.include?("for")
            if line != ""
                output << "#{line}\n"
            end
        end

        if line.start_with?("for")

            loop_depth += 1
            if loop_cap == false
                replace_var = line.split("for ")[1].split(" ")[0]
                iterator = line.split(" ")[3]
                loop_cap = true
            end

        end


    end


    return output

end




def initialize_vars(input)

 vars = {}
 output = ""

input.split("\n").each do |line|

    if line.include?("=")

        name = line.split(" = ")[0]
        value = line.split(" = ")[1]

        vars.each do |key, val|
            if value == key
                value = val
            end
        end

        if value.is_num?
            vars[name] = value.to_i
        
        elsif value.start_with?("[") && value.end_with?("]")
            vars[name] = value.split("[")[1].split("]")[0].split(", ")

        else
            vars[name] = value.gsub("\"", "")
        end
    
    else
        if line != ""
            output << "#{line}\n"
        end
    end


end
    return output, vars
end


def parse_vars(input, vars)
    vars = vars
    output = "" 
    input.split("\n").each do |line|
        if line.include? (" += ")
            name = line.split(" += ")[0]
            value = line.split(" += ")[1]

            vars.each do |key, val|
                if value == key
                    value = val
                end
            end

            if value.is_num?
                vars[name] = vars[name] + value.to_i
            else
                vars[name] << value
            end

        elsif line.include?(" -= ")

            name = line.split(" -= ")[0]
            value = line.split(" -= ")[1]

            vars.each do |key, val|
                if value == key
                    value = val
                end
            end

            if value.to_i != nil 
                vars[name] -= value.to_i
            end

        else
            vars.each do |key, val|
                if line.include?("#{key}")
                    line =  "#{line.gsub("!#{key}", "#{val}")}"
                end
            end
            if line != ""
                output << "#{line}\n"
            end
        end
        


    end
    return output

end


input = File.read(ARGV[0])
output = initialize_vars(input)[0]
vars = initialize_vars(input)[1]
output = parse_loops(output, vars)
while output.include?("end")
    output = parse_loops(output, vars)
end
output = parse_vars(output, vars)

results = @validator.validate_text(output)

if results.errors.length > 0
    File.write(ARGV[1], "/*error on line #{@validator.validate_text(output).errors.to_s.split("@line=\"")[1].split("\"")[0]}/*")
else
    File.write(ARGV[1], output)
end

