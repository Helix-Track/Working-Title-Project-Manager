/*
    BoardsMetaData.h
    Generated with 'sql2code' 1.0.0-SNAPSHOT
    https://github.com/red-elf/SQL-to-Code
*/

#include "string"

class BoardsMetaData {

private:
    std::string id;
    std::string boardId;
    std::string property;
    std::string value;
    int created;
    int modified;

public:
    std::string getId();
    void setId(std::string value);
    std::string getBoardId();
    void setBoardId(std::string value);
    std::string getProperty();
    void setProperty(std::string value);
    std::string getValue();
    void setValue(std::string value);
    int getCreated();
    void setCreated(int value);
    int getModified();
    void setModified(int value);
};