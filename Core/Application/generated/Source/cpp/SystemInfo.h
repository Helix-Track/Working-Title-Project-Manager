/*
    SystemInfo.h
    Generated with 'sql2code' 1.0.0-SNAPSHOT
    https://github.com/red-elf/SQL-to-Code
*/

#include "string"

class SystemInfo {

private:
    int id;
    std::string description;
    int created;

public:
    int getId();
    void setId(int value);
    std::string getDescription();
    void setDescription(std::string value);
    int getCreated();
    void setCreated(int value);
};