/** 
 * @file	Utilities.h
 * @date	Nov 26, 2017
 * @author	Rafal Chojna <rafalc@wolfram.com>
 * @brief	Implementation file with miscellaneous definitions used throughout the MathLink-related part of LibraryLinkUtilities
 */

#include "../../include/LLU/ML/Utilities.h"

#include <string>

#include "mathlink.h"

namespace LibraryLinkUtils::ML {

    const std::string& Symbol::getHead() const {
        return head;
    }

    void Symbol::setHead(std::string h) {
        head = std::move(h);
    }

    int Function::getArgc() const {
        return argc;
    }

    void Function::setArgc(int newArgc) {
        argc = newArgc;
    }

    std::string getMLErrorText(MLINK mlp) {
        std::string err = "Error code reported by MathLink: " + std::to_string(MLError(mlp)) + "\n";
        auto mlErrorMsg = MLErrorMessage(mlp);
        err += "\"" + std::string(mlErrorMsg) + "\"\nDebug info: ";
        MLReleaseErrorMessage(mlp, mlErrorMsg);
        MLClearError(mlp);
        return err;
    }

    void checkError(MLINK m, int statusOk, const std::string& errorName, const std::string& debugInfo) {
        if (!statusOk) {
            ErrorManager::throwException(errorName, getMLErrorText(m) + debugInfo);
        }
    }

    MLINK getNewLoopback(MLINK m) {
        int err = 0;
        auto loopback = MLLoopbackOpen(MLLinkEnvironment(m), &err);
        if (loopback == static_cast<MLINK>(0) || err != MLEOK) {
            ErrorManager::throwException(LLErrorName::MLCreateLoopbackError, "Error code: " + std::to_string(err));
        }
        return loopback;
    }

    int countExpressionsInLoopbackLink(MLINK& lpbckLink) {
        auto helperLink = getNewLoopback(lpbckLink);
        int exprCnt = 0;
        while (MLTransferExpression(helperLink, lpbckLink)) exprCnt++;
        MLClose(lpbckLink);
        lpbckLink = helperLink;
        return exprCnt;
    }
}


