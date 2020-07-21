function exportstring( s )
    return string.format("%q", s)
end

function myFileWrite(fileHandle, str)
   return(C4:FileWrite(fileHandle, string.len(str), str))
end

--// The Save Function
function table.c4save(tbl, filename)
       local charS,charE = "   ","\n"
       if (C4:FileExists(filename)) then C4:FileDelete(filename) end
       local file = C4:FileOpen(filename)
       if (file == -1) then
              print("unable to open file " .. filename .. " to save table")
              return
       end
       print("opened file " .. filename .. " to save table")

       -- initiate variables for save procedure
       local tables,lookup = { tbl },{ [tbl] = 1 }
       myFileWrite(file, "return {"..charE)

       for idx,t in ipairs( tables ) do
              myFileWrite(file, "-- Table: {"..idx.."}"..charE )
              myFileWrite(file, "{"..charE )
              local thandled = {}

              for i,v in ipairs( t ) do
                     thandled[i] = true
                     local stype = type( v )
                     -- only handle value
                     if stype == "table" then
                     if not lookup[v] then
                     table.insert( tables, v )
                     lookup[v] = #tables
              end
              myFileWrite(file, charS.."{"..lookup[v].."},"..charE )
              elseif stype == "string" then
                     myFileWrite(file, charS..exportstring( v )..","..charE )
              elseif stype == "number" then
                     myFileWrite(file, charS..tostring( v )..","..charE )
              end
       end

       for i,v in pairs( t ) do
              -- escape handled values
              if (not thandled[i]) then
                     local str = ""
                     local stype = type( i )
                     -- handle index
                     if stype == "table" then
                           if not lookup[i] then
                                  table.insert( tables,i )
                                  lookup[i] = #tables
                           end
                           str = charS.."[{"..lookup[i].."}]="
                           elseif stype == "string" then
                                  str = charS.."["..exportstring( i ).."]="
                           elseif stype == "number" then
                                  str = charS.."["..tostring( i ).."]="
                           end
                           if str ~= "" then
                                  stype = type( v )
                                  -- handle value
                                  if stype == "table" then
                                         if not lookup[v] then
                                         table.insert( tables,v )
                                         lookup[v] = #tables
                                         end
                                  myFileWrite(file, str.."{"..lookup[v].."},"..charE )
                                  elseif stype == "string" then
                                         myFileWrite(file, str..exportstring( v )..","..charE )
                                  elseif stype == "number" then
                                         myFileWrite(file, str..tostring( v )..","..charE )
                                  end
                           end
                     end
              end
              myFileWrite(file, "},"..charE )
       end
       myFileWrite(file, "}" )
       C4:FileClose(file)
       print("closed file " .. filename .. " to save table")
end

table.c4save (_G, os.time () .. '.txt')
