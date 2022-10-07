/*
    UserTeamMappings.h
    Generated with 'sql2code' 1.0.0-SNAPSHOT
    https://github.com/red-elf/SQL-to-Code
*/

#include "string"

class UserTeamMappings {

private:
    std::string id;
    std::string userId;
    std::string teamId;
    int created;
    int modified;
    bool deleted;

public:
    std::string getId();
    void setId(std::string value);
    std::string getUserId();
    void setUserId(std::string value);
    std::string getTeamId();
    void setTeamId(std::string value);
    int getCreated();
    void setCreated(int value);
    int getModified();
    void setModified(int value);
    bool isDeleted();
    void setDeleted(bool value);
};