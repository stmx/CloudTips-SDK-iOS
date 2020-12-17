//
//	ReCAPTCHAViewModel.swift 
//	ciarf 
//
//	Created by ciarf.ru on 21.09.2020 
//	Copyright © 2020 ciarf.ru. All rights reserved. 
//

import Foundation
import WebKit

final class RecaptchaViewModel: NSObject {
    var onCaptchaVerified: ((_ token: String?) -> ())?
    
    let handlerName = "recaptcha"

    var html: String {
        """
            <!DOCTYPE html>
            <html>
              <head>
                <meta charset="utf-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <script src="https://www.google.com/recaptcha/api.js?render=6LeTy9YZAAAAAGkzdnNg64z67vimf3zkD7woujli"></script>
                <title></title>
                <script type="text/javascript">
                  const post = function(value) {
                      window.webkit.messageHandlers.\(handlerName).postMessage(value);
                  };

                  console.log = function(message) {
                      post(message);
                  };
                    grecaptcha.ready(function() {
                    // do request for recaptcha token
                    // response is promise with passed token
                        grecaptcha.execute('6LeTy9YZAAAAAGkzdnNg64z67vimf3zkD7woujli')
                                  .then(function(token) {
                            post(token);
                        });
                    });
                </script>
              </head>
              <body>
                  <div id="recaptcha"></div>
              </body>
            </html>
        """
    }
    
    private var timeoutWorker: DispatchWorkItem?
    
    func start(){
        self.timeoutWorker?.cancel()
        self.timeoutWorker = DispatchWorkItem.init {
            self.timeoutWorker?.cancel()
            self.onCaptchaVerified?(nil)
            self.onCaptchaVerified = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 20, execute: self.timeoutWorker!)
    }
}

// MARK: - WKScriptMessageHandler
extension RecaptchaViewModel: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        guard let message = message.body as? String else {
            assertionFailure("Expected a string")
            return
        }
        
        self.onCaptchaVerified?(message)
        self.timeoutWorker?.cancel()
        self.timeoutWorker = nil
    }
}
