/*
    Users.h
    Generated with 'sql2code' 1.0.0-SNAPSHOT
    https://github.com/red-elf/SQL-to-Code
*/

#include "string"

class Users {

private:
    std::string id;
    int created;
    int modified;
    bool deleted;

public:
    std::string getId();
    void setId(std::string value);
    int getCreated();
    void setCreated(int value);
    int getModified();
    void setModified(int value);
    bool isDeleted();
    void setDeleted(bool value);
};