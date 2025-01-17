import XCTest

@testable import Usercentrics
@testable import usercentrics_sdk
import UsercentricsUI

class ShowFirstLayerBridgeTest: XCTestCase, BaseBridgeTestProtocol {

    var bridgeName: String! = "showFirstLayer"
    var bridge: MethodBridge!

    private var usercentrics: FakeUsercentricsProxy!
    private var bannerProxy: FakeUsercentricsBannerProxy!

    override func setUp() {
        usercentrics = FakeUsercentricsProxy()
        bannerProxy = FakeUsercentricsBannerProxy()
        bridge = ShowFirstLayerBridge(assetProvider: FakeFlutterAssetProvider(),
                                      bannerProxy: bannerProxy)
        super.setUp()
    }

    override func tearDown() {
        usercentrics = nil
        bridge = nil
    }

    func testName() {
        testNameProtocol()
    }

    func testInvoke() {
        let consent = UsercentricsServiceConsent(templateId: "ABC",
                                                 status: false,
                                                 history: [],
                                                 type: .explicit_,
                                                 dataProcessor: "TheProcessor",
                                                 version: "1.3.4",
                                                 isEssential: true)
        bannerProxy.showFirstLayerAnswer = UsercentricsConsentUserResponse(consents: [consent],
                                                                           controllerId: "controllerIdABC",
                                                                           userInteraction: .acceptAll)

        let expectation =  XCTestExpectation(description: "resultCompletion")
        let resultCompletion: FlutterResult = { result in

            guard
                let result = result as? [String: Any],
                let controllerId = result["controllerId"] as? String,
                let userInteraction = result["userInteraction"] as? String,
                let consentsMap = result["consents"] as? [[String: Any]],
                let consent = consentsMap.first
            else {
                XCTFail()
                return
            }

            XCTAssertEqual(controllerId, "controllerIdABC")
            XCTAssertEqual(userInteraction, "ACCEPT_ALL")
            XCTAssertEqual(consentsMap.count, 1)
            XCTAssertEqual(consent["version"] as! String, "1.3.4")
            XCTAssertEqual(consent["dataProcessor"] as! String, "TheProcessor")
            XCTAssertEqual(consent["templateId"] as! String, "ABC")
            let historyMap = consent["history"] as? [[String: Any]]
            XCTAssertEqual(historyMap?.isEmpty, true)
            XCTAssertEqual(consent["type"] as! String, "EXPLICIT")
            XCTAssertEqual(consent["status"] as! Bool, false)
            XCTAssertEqual(consent["isEssential"] as! Bool, true)

            XCTAssertEqual(self.bannerProxy.showFirstLayerCount, 1)
            XCTAssertEqual(self.bannerProxy.showFirstLayerLayoutArg, .popup(position: .center))
            XCTAssertEqual(self.bannerProxy.showFirstLayerBannerSettingsArg?.generalStyleSettings?.links, LegalLinksSettings.both)
            XCTAssertEqual(self.bannerProxy.showFirstLayerBannerSettingsArg?.firstLayerStyleSettings != nil, true)
            // TODO Assert style settings

            expectation.fulfill()
        }

        let call = FakeFlutterMethodCall(methodName: bridgeName)
        call.argumentsMap = [
            "bannerSettings": [
                "firstLayerStyleSettings": [
                    "headerImage": [
                        "height": 100.0
                    ],
                    "title": [
                        "alignment": "START",
                        "textSize": 20.0
                    ],
                    "message": [
                        "alignment": "END",
                        "textColor": "#8a000000",
                        "linkTextUnderline": true
                    ],
                    "buttonLayout": [
                        [
                            "type": "MORE",
                            "cornerRadius": 20
                        ],
                        [
                            "type": "ACCEPT_ALL",
                            "cornerRadius": 20
                        ]
                    ],
                    "overlayColor": "#8a000011",
                    "cornerRadius": 50
                ],
                "generalStyleSettings": [
                    "links": "BOTH"
                ]
            ],
            "layout": "POPUP_CENTER",
        ]
        bridge.invoke(call, resultCompletion)
        wait(for: [expectation], timeout: 2.0)
    }
}
