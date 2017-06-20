#ifndef GLOBALS_H
#define GLOBALS_H
#include <QString>

#if ANDROID
const QString extstr=QString(getenv("EXTERNAL_STORAGE"))+"/carpenter-structures/";
const QString tmpDir(extstr+"tmp/");
const QString scenariosDir(extstr+"scenarios/");
const QString uploadedDir(extstr+"uploaded/");
#else
const QString tmpDir("tmp/");
const QString scenariosDir("scenarios/");
const QString uploadedDir("uploaded/");
#endif

#endif // GLOBALS_H
