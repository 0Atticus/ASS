class String
    def is_num?
        return string.to_i != nil
    end
end



def parse_variables(input)

    vars = {}
    output = ""

    input.split("\n").each do |line|

        if line.include?(" = ")

            name = line.split(" = ")[0]
            value = line.split(" = ")[1]

            vars.each do |key, val|
                if value == key
                    value = val.to_s
                end
            end

            if value.start_with?("[") && value.end_with?("]")

                temp = []
                
                value.split("[")[1].split("]")[0].split(", ").each do |i|
                    
                    temp << i

                end

                vars[name] = temp

            elsif value.start_with?("\"") && value.end_with?("\"")
                vars[name] = value.gsub("\"", "")

            elsif value.to_i != nil
                vars[name] = value.to_i
            else
                vars[name] = value

            end

        elsif line.include? ("+=")
            
            name = line.split(" ")[0]
            value = line.split("+= ")[1].gsub(" ","")

            vars.each do |key, val|
                if value == key
                    value = val
                end
            end

            if value.to_i != nil
                vars[name] += value.to_i
            else
                vars[name] << value
            end

        else
            output << "#{line}\n"
        end

    end

    vars.each do |key, val|
        if output.include?(key)
            if val.is_a? Array
                output = output.gsub("#{key}", "[#{val.join(",")}]")
            else
                output = output.gsub("#{key}", "#{val}")
            end
        end
    end
    return output, vars

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
                    if iterator.start_with?("[")
                        iterator = iterator.split("[")[1].split("]")[0].split(",")
                        iterator.each do |i|
                            i = i.gsub("\"", "")
                            output << "#{loop_content.gsub("!#{replace_var}", "#{i}")}\n"
                        end
                    else
                        i = 1
                        until i > iterator.to_i
                            output << "#{loop_content.gsub("!#{replace_var}", "#{i}")}\n"
                            i += 1
                        end 

                    end
                    loop_cap = false
                    iterator = nil
                    replace_var = nil
                    loop_content = ""
                end
            end
            if line == "end" && loop_cap == false
            
            elsif line != ""
                loop_content << "#{line}\n"
            end
        elsif !line.include?("for")
            output << "#{line}\n"
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





output = parse_variables(File.read("style.ass"))[0]
vars = parse_variables(File.read("style.ass"))[1]
puts vars, output

output = parse_loops(output, vars)
while output.include?("end")
    output = parse_loops(output, vars)
end
temp = ""
output.split("\n").each do |line|
    if line != ""
        temp << "#{line}\n"
    end
end
output = temp
File.write("style.css", output)
