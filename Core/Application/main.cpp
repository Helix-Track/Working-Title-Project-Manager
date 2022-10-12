#include <vector>
#include <iostream>
#include <filesystem>
#include <drogon/drogon.h>
#include <argparse/argparse.hpp>

#include "Utils.h"
#include "Commons.h"
#include "BuildConfig.h"

#include "VersionInfo.h"

#include "generated/Source/cpp/Label.h"

using namespace Utils;
using namespace Commons::IO;
using namespace Commons::Strings;

int main(int argc, char *argv[]) {

    std::string title = "generated code";
    std::string description = "READY";

    Label label;
    label.setTitle(title);
    label.setDescription(description);

    auto errTag = "error";
    auto startingTag = "starting";
    auto paramsTag = "parameters";
    auto installationDirectory = std::string(VERSIONABLE_NAME).append("-").append(getVersion());
    auto defaultConfigurationFile = "/usr/local/bin/" + installationDirectory + "/default.json";

    argparse::ArgumentParser program(VERSIONABLE_NAME, getVersion());

    program.add_argument("-l", "--logFull")
            .default_value(false)
            .implicit_value(true)
            .help("Log with the full details");

    program.add_argument("-d", "--debug")
            .default_value(false)
            .implicit_value(true)
            .help("Additional information related to the parsing and code generating");

    program.add_argument("-c", "--configurationFile")
            .required()
            .default_value(std::string(defaultConfigurationFile))
            .help("Path to the HelixTrack core configuration file");

    std::string epilog("Project homepage: ");
    epilog.append(getHomepage());

    program.add_description(getDescription());
    program.add_epilog(epilog);

    try {

        program.parse_args(argc, argv);

    } catch (const std::runtime_error &err) {

        e(errTag, err.what());
        std::exit(1);
    }

    try {

        setLogFull(program["--logFull"] == true);
        setDebug(program["--debug"] == true && logFull());

        auto configurationFile = program.get<std::string>("configurationFile");

        if (logFull()) {

            v(paramsTag, "Full-log mode is on");
        }

        if (isDebug()) {

            w(paramsTag, "Debug mode is on");
            v(label.getTitle(), label.getDescription());
        }

        if (configurationFile == defaultConfigurationFile) {

            d(startingTag, "Using default configuration file: " + configurationFile);

        } else {

            d(startingTag, "Configuration file provided: " + configurationFile);
        }

        /*
            Details on the configuration file:
            https://drogon.docsforge.com/master/configuration-file/
        */
        drogon::app().loadConfigFile(configurationFile);

        auto logLevel = trantor::Logger::kWarn;

        if (isDebug()) {

            logLevel = trantor::Logger::kTrace;

        } else if (logFull()) {

            logLevel = trantor::Logger::kDebug;
        }

        drogon::app()
                .setThreadNum(0)
                .setLogLevel(logLevel);

        d(startingTag, "Ok");

        drogon::app().run();

    } catch (std::logic_error &err) {

        e(errTag, err.what());
        std::exit(1);

    } catch (std::runtime_error &err) {

        e(errTag, err.what());
        std::exit(1);
    }
    return 0;
}