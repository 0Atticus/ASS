class String
    def is_num?
        return string.to_i != nil
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
                    i = 1
                    until i > iterator.to_i
                        output << "#{loop_content.gsub("!#{replace_var}", "#{i}")}\n"
                        i += 1
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

    if line.include?(" = ")

        name = line.split(" = ")[0]
        value = line.split(" = ")[1]


        if value.to_i != nil
            vars[name] = value.to_i

        else
            vars[name] = value
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

            if value.to_i != nil
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
                    line =  "#{line.gsub("#{key}", "#{val}")}"
                end
            end
            if line != ""
                output << "#{line}\n"
            end
        end
        


    end
    return output

end


input = File.read("style.ass")
output = initialize_vars(input)[0]
vars = initialize_vars(input)[1]
output = parse_loops(output, vars)
while output.include?("end")
    output = parse_loops(output, vars)
end
output = parse_vars(output, vars)
File.write("style.css", output)