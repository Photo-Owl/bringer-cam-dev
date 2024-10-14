import unittest
from appium import webdriver
from appium.options.android import UiAutomator2Options
from appium.webdriver.common.appiumby import AppiumBy
from time import sleep
capabilities = dict(
    platformName='Android',
    automationName='uiautomator2',
)

appium_server_url = 'http://192.168.29.74:4723'  # For Appium 2.x

class TestAppium(unittest.TestCase):
    def setUp(self) -> None:
        self.driver = webdriver.Remote(appium_server_url, options=UiAutomator2Options().load_capabilities(capabilities))

    def tearDown(self) -> None:
        if self.driver:
            self.driver.quit()

    def testTest(self) -> None:
        el1 = self.driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value="Yes, I do")
        el1.click()
        sleep(1)
        el2 = self.driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value="Sign in with Google")
        el2.click()
        sleep(1)
        el3 = self.driver.find_element(by=AppiumBy.ANDROID_UIAUTOMATOR, value="new UiSelector().className(\"android.widget.LinearLayout\").instance(3)")
        el3.click()
        sleep(1)

if __name__ == '__main__':
    unittest.main()
