require 'buildr/as3'

FLEX_SDK = FlexSDK.new('4.6.0.23201B')

desc "Main application."
define 'Alone_LD22' do
	project.version = "0.5.0"

	compile.using :mxmlc,
				  :flexsdk => FLEX_SDK,
				  :main => _(:source, :main, :as3, "Main.as")

	compile.from [
		_(:source, :third_party, :as3, :FlashPunk)
	]

	compile.options[:args] = [
		"-static-link-runtime-shared-libraries=true"
	]
end
