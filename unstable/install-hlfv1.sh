ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.11.3
docker tag hyperledger/composer-playground:0.11.3 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ���Y �=�r۸����sfy*{N���aj0Lj�LFI��匧��(Y�.�n����P$ѢH/�����W��>������V� %S[�/Jf����4���h4@�P��
)F�4l25yضWo��=��� � ���h�c�1p�?a�,��(�"<6e�O �@��
��� OK���x���Ї���.��)ʆV_U��KQ �<a����_�#�:��t�wǹ$S��m�����`���(?�R�4,��� �w�f�o��A��Z�ރ�3BJ�
���T>K���\v��g �q� �	[��9)Cס�NZFK� ��֒���?K(Ө6��	%�sP�k�i�K5qq�z�@�}6�̖s�_s�����a]�*�a�H����G��W,�D#�ʚ=���ADf&װ��B́��M偙� %\K�Ĵ-SٍD��ax!�Lb�v���3E��R>�Тtd4Q��Q�FI3�=�̥1f�j����,�"ϙ�k�;�c"�9l����g����2�ݽ�!Ǆ+��u������`�:����2��[,[Gt�9�nʽ��� C�$j��:��S�K�ZEJ�N�<� ?�}3Y��/:����+O��Z���4Ѥ�;�q�O���ވ������b�����|<.ܴ�c��Q.���bO����́/|��3����1н*lw������g9�?�!84�q��6��:��w���G�ݡlõ��/��$���u��1)V��*�Z9%�c>\��%����&�9����Y~���˃9�eO�'�.���u�F��l�#���t�v>|n���A�?���i,�Q�C* ��>�Y��x�5޿�2�bѾ��0a&,x�Ӿ����f� xd0����c@֛��Z���]}�&v� ��v��Zx��`Zj_v0���B�$�Nǰ��*��*P�I�D��⼌.��^�z�M'5C�*���$]14w��{�~GM��m���DdWK{�����W՚!�R:j���mW3A(��`{|�	H��q]hҳ� �\�_��Dx��'�����e�a~�E����9���QT"L�1W��Fi�p��OԴ4�:p_p������c�l,Ơt�	�F�����`+�\�8Łӑ�U5�(k��>D�X���z����M�َa�xI}��Cv���&a!`� ��KJm�wؚ<d����i��5�RG�*��=\����m��{�gA�]M�.;�B'��j��qn�q9�:wc�e��Q��4k� ��Z��+<��� �Q#_Il �` Q��PȘ^�c�09n�	���F��)�U�A�0�'�cL��p�9�y�:摔�}I��� �8�е!�������I�`&�v��9�_]Uw�)�io���頁�p��Jt�>ԠlC`C*tT�bـ�My?���9���6��Q� �9��_R~EC�:�6��w����kD��E7��������$��������׈S-���y=[���������Ж�i�p���0g�ǌ�`�����o��u����e�����jc���<��v��]xvR����Yg�g��f���M�z���������g����k@ZY?�5�ҹ���	U��U�*�r�7���_����[veg���c �j�D���%�r3b��K�եr%W*����6�}�w�6pu:?"#�v{�/�_��%0Y`�С�fÛ�D5�����,D,ީ��[����Y5W�J���TO�ͣ����j�/g�0Qz��>`�Ђ{�}Ǆ^='QY�����w��܆���[|� �[b\�H�.("S\��k@�?Ͻ&f)`qY<&::=���"&C�wEG|�;�"�4[ z���/g����sp�h'�G��g5X���Xfc��6�ߗs���<�p��GYf���������?��V�3��UG�i 2-�R/�hG�	�W��ֹ7̑�){��m��g��&�s�x���	������?����~3������a���?.L��� l�?k���ޅ:ڃ[��e֏��T��?��z�޴�ށ�`�v�O�� Tm��:���{��$�M�{h;�p���9q��Z�3"��t�����JL���"��U�� (�u�5���������>zL�h�ϫ��)4�ꁐ������� �/�an��7af������/�fV��������*��cD���G8�'��L�8`G�`0�3�ĥ��^}���ޡ؋��Y�1a6̌Jᦖ.t;�G�ݷ?����?/��#�R���&�k=�����v��<�q���Y�)�k��Ƃ��f��B����:��3?b��C�5�|h�7b��������Dg��e7���o���w��<��<��\W=���u�mB�$P�쀟~R)~^��krh��O�.q���A�`wT��_�3y	�f(��1l'x��"��� r�Ǿ۸7:�B����RA����|J3�ǲ�TU��X�.R��х�LeR���td\[�|4b��l���?��1��t��|+���k<4����6��mc����1a��g������W�%7s��������+���"�jۻ4�w�D�9�z����ʕr=u��D��T�y)���y@�M�v��f�GC����DSS8��S�DCn�#8R��tv(I�31�.K��X���RUJU	�A�z�$}X��{��^ -��V�ru_��6�,�/e��b�,/ե�^ZJֲ3��{hDf�rg�CL�^`F��Ů����,�_�R�r�z21�7 �K�<��]�Mui
��,U�
��W)��f���5U�'|���hw@H۶�	�� �
Ѝ&��%�Y��ۃ�z�M���O-���������Ǧ�?�|�[|��?b7z?�U��)��7؅+}7@��� "���������ѭaj��&�w@W���x�?�]�~�S@,����E�V������n1����^Q@K���?x��7��M���ò��K������hT`7��~��k�i�_Q<�(����0��u�����@�ْn0"[�ߗ���F�F��-!x��
,��5��|jN����e��}.\h��ѱ�����7����������װ��Ey5t���J���֊�*�fc�̝�Y��ϥ�����	�o=�����䖪���8�1&B�.�Z�&���"�����
^ ���O���8�Y�����G��a�(�5�0�!0�6 OC�@>@�3H��o�#�.E)���P�7z�(o�R��/�c���}��`
�!΀��'6��\�WW�_Y��w �/�,|X�*!1�����"s�M�E1.2獔�P��"���%�b�77=lxƇDc��n��7��?Xz�i�;�����������Xy��������Ţ6����'���/k���Ψ�|����������G��S����h�Qx�K�Va���j�xe'���	���2�Y���D#��O�ۈ�\cG���+����+�Jo��'�45�/��z��'��������2t۰��m��ֿP[�E�:���j�r���7_MTDK���fo�e럿��-j��|���xl�b��?o=E��4N�ye�o���	?�5,G䧞�au�'�Jm�����F���8�����ic���f�������,���j��w�e��Qq�ɏ��B�U���Q.�Q���%+�3�J�~�m���q9��q��eyYn00k�%�evZ;	�R�Ǝ��(��Bl�)3
bEfw�r���e9!�bP긶����m�5 w'�!)esE����\&��I}�r�T�<��T[�b;W�nI�_��dvh�����Վ��I��8�]�3�(�R� v�"[���B�^/\H�b9�.�QU�T��id�^#�ƕ���̹X��j����d����2�	�]�p;٪���0�R61<���ӷ�N�m�>�����O���S�J\��^���b�;J�PU��W��R5��s�ƌ������F����N�����4xS�]J�8ܻT�pp�el������*�G^�/
��z�˸9�txr,��o��K�UH2C���ˎ|,�h,�BE�`6�(�-�+���)�d!������ؖ����{ �LNLfݝ�����^T�����ǋoՓ��s����8��o��z�{\�k�Z�D>2r���B!~?5�b%����r씗�����ZM�"��Q�L�ddp��x��x��˅��ڑ�sQ,�lܫfnp�-��\�g��n<�K&��V9��~5{Hrr�d1�L��ro�}��nA4�=C3���X�j��Q���b������Q=���|����~�*��	����D?Ռ�s�p3z�7æ�1$S�r�B"�V��o��C�Q�)>�7�����^',/�sĀ���
G_��Ϋ�cŵ�?Y��2�w7��`X6�Ğ��#�3#�o�sޢ��(�q������>u�7���_���N�����9���I��\-�@:!�O�B.���d�5:�e2���������C�$�n#��:-�u�¾��챦��L*��#�s;��J�b���Z�lj�ˌ������f�j��S��wkã�02j�}.��S�c�fn��ANV�H�����*{0Y���Sj���v�S�������Ϯ��f�_|���m|�o����ss�~s�w-\�k�|.\�3݁48���)�h�
I�GJ��-Jr|`I�tM�f�.��n�fᛶ)��O)��9��T���[��)':�!u�=8�w/����������I�z����b{o/��OS��G��w����8�����Cy�k �,�O����M��Z�H��"ѓ�d��2�@�4P�i6(C��0��b�߆����!ϗ�R��F-���C�6��E ���M�HÖ��$b�h�.YW/�C�=Y����?j������ =����V���x��C�(��n� �FOV�]��"��6����P!�X���xAjƀ� aU�A���D!et#E������y��y�ߥ�x|m�C�������6���K��������f�G���� [G�t�KW㗄�.74��ͅ�T�H��pd"gCõ����ڵ_�(��㮍������q���I6
C'$�߾�0�B3�&�e��n{�OJ��m�����xl�jw�����n�m�����`���$��\�8 !�]�ZA�p����p���x3o�(������_����_U�hǣF��?�D�
���mt8�|p�юA0"�d�@��eM4ń�9�ViT���*AR�6H�*t�շ�74�$ו��OH������B$��&��}���|�Pf���+�d �	�rPN6�m��ؗ�c��&���|��|�Y��Y���_�;���3>\�ؕ���~��k����3��?߻��{7��6?��lg@���&�W��g�6P]�	��[���D1�h��}qpoC;`m7{�g0M:��/�=�r	��iJ��!m4��AjH�u����N��\�-�[�i�VI�Kҗ�g\<�?�C;�^�^7 R��1Q\S��� �Ӄ�F�����e��u�࢖�1���� ��-�9�"��d���zJyîmL��[���ҹ)�{B�1���sg8:��|>��9���e�6�W�)�}X*2M�dڵ�HU{}��`M��l�6�-��1D�A����	��>5�A[�X!%���\���d�J�:QT��i�˒��ˆ2�a�kk>?\���뚉�����l�tۡsc���H�d�OX��nU|�����+����sH���S���/��ĵ�|+	�]��$O�7��5�<������nt�5����Ue=�y �ם�u�����"���2J}}��+�{����o�~+����~�Ǉ?��9a�����O���>��>����"~�"~�"į����o���
��vd�3)4��/�^"#G%%ދ�J"����q�K�2�t<ދ�TR� ���ۉD<#'a���S�rZ�vC��'��W�'�w����ό����������2C�!�	�z$��o���f��>}��m�����~��
����������Ճп<�Ӄ�ÿ��v�� c5S�`���J?�n�[z1SP�Y�fX��Q����R��X��Y"�q[����" ���t��}��X�u�p@XsAlG�)���Vrvd^^�Q�=�j	�`��I��i�P��%]t@hm�֏E�.؜�4���l�5w���4��B�m�h���ٔ�W�b_���hy&�v��Gܜ����K��x�E�R�9mG3�P����iX����ڍ�v��U��+m�M�>�<*.��\:�Ka��$,[<o��#ji��|�릮Xt�R�����D���\y֠�홒�7��0�垐��,�f=R�k�0CþW�C�Nc�X�G��y�ɡ��ژXt��6��gKz�Qg�8ǫ55,�<erj!jqS�>�C�SL�}#����cQj����<�	Sd�e����br֛g��*X�<���}��LN��q<k�]��<*M�,�?ѻ�D�Z��U��4=KI�2��#~��Q�	�c�^-�_P��߽V���$$�
�$$�
�$$�
�$$�
�$$�
�$�a.�P�]��F����B�⏯U���ξ�v�ىH�3�ْJ�˝�^ώ�N�����F�\h����@��.��@�B�}k�C �s;ד�� �nމH�۹��?'�޲���"�|�8�͙hi�C�c����f�l��r��i�Y��fT8)��9�Z|2�k�x�n�r�z2����6@/QK^�~�����Iu����3� 2M�<[�T��/T }���nJ�v�_;�/u?%�0�g*1�r��B�	5aWL��ڹQ��f�E"f�Tb���R���z�0�*\�rt�%��feҭr�ǂޠ��g�䐻B�vݽY{����o�~i��У�N�-��;����vs��_0���9��޲�e�7�}A<�:�h��UC׺�Ч�wv�����>
�ta��M��tك�o�u
�v`]��zͯ�e�B?z�j��B��(��o��\�������<�΃���Q�]k�JKh�d������UDSc�LkQ�R�����^��@|�>?����g��zߵs�aa9;�T[.�6Q� ��g���D�A�E8��fs�k�lk��Lӳ�d|�
�B��H���u�Ϭ��06�d�b��(Ԙ%�+���l��ώ�J�Fd��xkv$g�T�2��R���#Վv��&��PR��8o[�N�6ӽ��d�+�?.T�&ND��X�4���-��g�t؝6��9��f�j0`D�BX�� �jMc����Pc谪��^~?{��JY o�C4_��\��h�=X�GĚ�T��e8Z��e1���%J�7��c*"*'���#5���5s8h�]!� U�qĬ�=*�gFJ?�+��٨��ϊ�p��Fx��S��U��ޯ]�4Y(K~�\k�<�քi�ĥKS��������S`x���6�ܒ>�dvX�{��𵊉��"���|�-��`Q���;i��f�q%O݉�껧�����[=��RK���7s�Dp
�,Ɩg�ej�\՚�@����v����[�J����Zs����'�zI�:v}��Ppru^��(�e��N�N6�����[\�B��ʜ(g���e9c�5�7h�5�	C�U㼚+�g�ޛ�Z��#8��*e����������k|����{��*�αR,�bSs�FjV$�X����#p�y�.B�QY1���A���\��uG���>5(F�HT��F���={�����Չ���b�H��lX�N��T�2LIp!*�%��:��Ӯ#���Q'n�#�m�L��.�x΄X��W: �c�3��p�s(Dp�{�CiG�Z�{��I�Q�j�Ho�̄�Gc.kҽV4=������:�i���c��rRo6��~>�/�әF���	�(�u(��Q�8�T���c�L�|���B�͑]S��p���?S��.;! .���;&�/i�4C��b�&ͧTB>n��>9�̫�lH��hB���>�a2Z3�1oG�`(���[�e�Åٸ�;�n+Ө�z��J���4�
}�>�1�n .}7�N0tf�ߛg������1�G�;��}�9�(�n�M⍨����2���U�iM4��Yh�'��Ђ�22���+��Coo��n�${���2�R	=��C���_R~�%�ao%�G=i<�<�8("@����̓&|�ψ������Xq?_N�����F*��$�QhO�&�o�S�1oX����o9�,������|r�x��Z�'�i*f(�%>t�O����P�K�"/M:7�	_*;�k�_n����?�'��7����5��"�؅�������^��~��}��?�|һi����d�^O��N�!ݼS�LR����d���0�t�a2fLr&`�X�PY�DHo��
��:*�e�˻;� \`�4�����k���U�|�;��g��AU�k� �t=/����j��xͺ����֋,�)�/�r�,�r���[���@mM���+z_���@����q1�u E.��A�0�I�`�|t�S���q?Qp�.��� ��j�{P���b�p�8Ȁ����	�Erjz�њ���tB��E�}c���H�>5
�\~�~y��K�Z���/��+��V��I 	g���}�E%>&���.�a�\��N�%���!�ac�S����;Stc�A����<k�}T� 7�E��Ԁ�") ~`5�y�g��,�OV�x�Vl���B���Ms��6�B�Ǝ��auH�m
~�W�!5�Cs��^:��T`
cʅ�^tO�[V'ڨ���~H��ѹe�Xu�J���Nd_nݑ�q���ʦ�7�7�{��厉Fݾ1A�6,���Gk���������_o�A��'��db�&>�Y�_�1>�z:r�?4��bS1zu�1r�+^^��v�x#1��K8�B#�P��7A|�[� l�p8U!)љ���q���Wʫm@��g�7"������|��#8ٌ	f�.0li�-YE���U�u?�Ɖ�|C�~�Q��$Z9p`�^]AZ
��e�a�g@ӝ�0��C�{ӻ7 �p`�nN	��)۟o�ýl��U/c��Z�S_0D(Olt`2���n0���ᡶ����b>��C2j�sG�$(�YC77��CXe|��5��+�ǚGsRp�1�C0׆�� ۱2¦ �l��ظ����!G������vT,����Yy�˕:�ް�u�"[�L4��fɫ*�*v�2qn�d��L��`��8�B[6�7��������	:�ۂ��1�^���|�D�D�*M����j;�V���H���G�D���Jf&� �Xa]3��4��<�{ +���Q�f�Q�"r�M��Ct;4��&^Yf����m:�a&���,Eps�yU4��E�Z�8FSv'���|"�����u7�7f)�mL��X��_�q�p?�j\8�W��3D�m3����`[o��j����.މsm���O�����o�����__��8V�O��Z׉J�ܹ��J|���M�JCԁ�j�u�f�|�4K���1�������[26��1WG��4d�����W�B��r|���������g��5q�+D�2��I)
��He�
HĔX��L��]�Gɩ@T���3QY�I�L��iD���8������=tŊs�
Ns/�ai�|�%?ݬ��Oa�j*�4�ƭ��!���e�b,���	 IR$���d SQ%ލ�  ��g�T$�L+1 ��	��Lg�xJ�@(P0�Sɹ ����S�S,�܆J@\��<wA��q�������(�mC�m����^��[o�To+u���a���\�.��*�w̕�Ɋ4U/'�"W�Y��5�"8��\J��m���^쿆t�~yk��lY��QY�$4�<�,�@v5���B���[��++���pNv*����1�ª�V���V5�?��`��Y�Z�Q�E�Ѥљ9n��ؾ8N=q����wQTx�@D�Xꦄ`�ۗH��+�S.�� �t�g+u��<_ΟV9��1���l����
��t���f~��X8��l��gӑ6?��h�ux&��t�Wfp�✨�S8$�\@
�z�v�8���f��J�f-Tb�R����2'�*�#�G��}�녮鎳&y��:ܫ�X��4�¾��:�c�0oC�E����"���Y݆�2W�g+�l�e�6�/{W֜��l��+�;u��[�U}� !��҄�'	����`H����N���!&hKk��ݽ����.��0UN����~�n���^^��ǫwm���ȟ���a��E������S��&�����?��������������l����W+���r���o��u������Ͷ}���[��FOw�����}?盻�z�,���z��#M���4ϟ�|x��/��%]�������}�o��s	�^1��&���P$�A�w���z�3^�����4�����o_��~��34O��� ��u��M��7
|�������P �X�7�?O�#�OS�s������x����|"P�e��@��?9��8����G��������3E?ҿ,�wg��?$@���H��Q�(&Er$�u��"�`�pa��$�T�")����&X1�(�X��M?�����!�gx�V���/$�F�=����?�Qi0Yf��j�w�Q�uG�r��2�Hʻ��q�������ϸR6�~�уt!���p�-]&����#�α���dJG~���4<�3��u���6�u��yM�1���d������ٟ�����a���q�x�()�{����%�O
��G��&����@��?(,��z ����7�?N��Q�`���i}	>5�����J�����G��ډ{)�,z ������<�?
���W��B�(:������4���� ��9�0��.�|��ԝ�O��@�_�C�_ ������n�?��#�����C��Q����?
��ۗ�?^|����Ak,�n)�ץZ̥S7Wn�?O�����z���^Z?���~^^#̚����K�'���<�>�e���ϧ�Obf�?T4q6KKƩQ?*������T��,�n��A�2kl��z���L���v�S+�b|�T��Cm�}\��������������Ϫ��7B�'5:�w]y�o�W������1X���l4^o��}����<w��2���̈�$ιSi�t�m)Y�j����h�ը������YG�.Ey��n�Ͷcwu��b/u�[� �����wm�@1���s�?,���^�.Q��E�������H �O���O��Tl�G�Ѡ�P ��N(�/
�n���?���?��X���7A����!������b���_������a&�x�Ѱ�6﮺��%����q�cX�{���T�/���5w-��a@�`�Gun&� �7�����U�.�d�᭥|!4J9�4#�)�$i�rS��#�5T������[���װ��>��eSίq�������7B���ڹ���;�'���_{��a�6�r��еM4I���O/cm/��9���(V�j�Uґ'r�{`�|w�ʬ���󊩞�+9�H#CR�'�zfoa��@��X�?���@�� �o�l��!�/ �n���3����#N��JG�$OE���ȑ�$1��a(�!�3>/�4�$�!�HL@�$��u������!�G�������^cz�(�v�R�x"]��~{��,��}^�V��&	����-���ܳ��>�ǻ�Iz�=������p������m���j�X2j�n-I}�in�M���*
��K��n�9~T������?�C��6�S�B����_q������0`�����9,�b|B��������,[��zi��'B�;�3��Ļ��V�Sϛ�����S��7���Ԥ]��uL�����U�9���(w&��<��%d'Ik��ܞS:�s�6ڕ�N��y���.���<�������oA�`�����xm��P��_����������?������,X�?A��gI�^�������;a��*��n1���'�ax��M��?�ѓ�e�I����g q}�3 �o��� g�V{�p*�U��e��3 d{?Z��!�K�l�4N�%=#g�vD�K��Ҩ�F���:�֩���.%V��Y�Jg��@۪�\�����N%+[.���D��w�]?y�
����U/3 l���r��J�W���$��+�h_����[�}O��:e�z��Db��5h1N+�X���j�Ё`�cS)���2�F~�i�Po��4ʦn���k���n])�Ѯ~
��pب)��p��%��G�M�]��VS�(�X*�Ϊ�=�/ϳ�ʬ��lc��<9(U�g�zc3��n4�A�Q��ǂ�C����C*<����������x�?P ���;�?���H�<��*��E�N !�G�������b��(��/H�%���A��H
�Qt̆�/�����ȋ1��e���t$J1+Ĕ��14v~p�����r�� ����Z�nv2�.7\��.Mp����d��Y9;�6=��[&��������h�`�����ة�ZU��mj⾔w��QZ��"�Z$���֢���s��G|gW3]�����*�^��m�̢����?�ޙ��$�x��X<�-?��C���i��� ���������-&��#����������A�" �����8���_�����������P�Z�m�Z˞U:Fe�z\��J������TH��&�O��:m����~_^#�S�}9�&~Z���}����>'�?�V<�����Nl���N�쭚{�L�����xmL�;ݺR[6g��0︣�ߐ?r&�<�[�h9���Q��{�~�&yc��*MSf���,W{�z��m-�^Qέ,���C��m�9���z�ġ�Z[R��愮s5��w�Uىl�j�*�6l�P�dt�1+�'��K���+	���β��=i�F��H���V��*+}��FnJ��!=�����Qe%aYnGƺ,p�g�����q���[�����e�ׂ����7��ߩ��i��C����o����o8���q�/�����n�����q@���!����������( ��������[�����o�
|���K/����	��������	p��$o��P�������?����B������p������G��!
�?����ݙ��H���9j���_�`��	������.�x���M��?��!��ϭ������0�h) 8�����@� �� �8��W��s�����X�?�����!P������H ��� ���Pl�G���#`���I��E��ϭ�����{�{����H��C�?r��C�q�������?:�����G��C��,>��jC�_  �����g��0�p��:����>�� 2�8�x��J,����b��'B�_
(��%�e9������8�?�S��o��v��#��i�ç��Z;G���"P�J��%7`�	Iy��4V��4�<���P�ت��������Ӱ��nܑ-U�;۽�ڮ�Y���T�U�t�u�*qB���{�;ܑ��c�����$Q����Z��-:��P.k����j]2^Ċ9^������K}�1�?�����l��������C�Oa���>��sX�������!�+�3�k���JY��WJ�ƚ�J�Q�֦��ԩ��f�j���֗�c�׍g��s�̶֩J]z��d����`L�n�I|�cSv�;%�v���p}�ʛ����-�^��d�N�,����Y��x��7��!������O���� 꿠��8@��A��A��_��ЀE �w~����A�}<^����_���S����-�tv:݋Jb��r�WI��{�vi�)��U�u0����x�1릻���a���g҆g��p$d�b�H6��QK���4�T���y����F�IS~*�N��1�e'̈́_�'����VjVW9q����㕾x�]�N����nE�M�|/l�D�(��<�M��f��˵r��c���)Z R�l[���"1D��-�i��6��f�P6u[5j�!p7�f��43##����84�����R�9��D1:����R�_T���Y)�dz��k��6̬<Z�9ac����x'���Q�}�<��W��Ҥ@����I���_$���>�������O����������o$������%^����:��$E�� �O����/��h����<=�*������<�w��(�R��ꪪ����~a�����3)IiFc�1oN��@���Mv��?T��a�*�>dܴ�z:+�o��aV�kʏx�܏���5�g�z�x�g�S���$O���%uy�\^\K�omK�]��$�c��P�f]ME�/uN}��n/l��R�ϝ�N��Ƽ�Х�^%gk]M�Q����	��J�5��e�ZeNɚ���]w�W��I��'�xoW���r��V����7�t�;?/k�$C������q}s���]+������Ğ(�"��awÔ{�<�~Lu�en'�}�fs�iLBmK�|֬u�e��&k�.Ozܜ8�B%l���Î�^_���` ��~A�s����SJ�D��e_ɝÐ��� 7���'���;?v=/�KNK����7��,�wS�翈�F�	G<���0)���R��e����$͏F��2��g�������c2�"���(���������!�����d$׼lg�'�< 	݋��^����]\?|�3F=������V�|�V��ȕ�Z����⣟�K���?�%�������[��?$@��C�c�X���m��	^��5O����5�gd��M'J[�-]��h����.��_�W������.	6�m��ٗr?�=��K�xE�o`*�S����{J������$sj�r�*5a��{Wڬ(�e��+�z/^�//�������<�L*���V�o�^3o�VeVV^�ҽ"2��p�u�>g�uxZ)���!��H���CsYs�N��dm�(;.�[8M[�Y��=��8:.H6�����ˑ}e��!�:�w�C����pv�E-��R���&R�펕��>�[{�����m"���Xgf�ֽ���#{�3�\ϺI�ba���Cw=�u�����u7>��&�ڜg���(/^k*����f�'���?���E�Ľ�������J�n��*�U�*A�3~:����05�Rq��V�d���e����d^�U`���������*��o����s�OlЮ/�F[��Ʊ7B�5anl��#9�wu��i^o8/��/[RՂ|�l���[?����7��1�Y��/Q{�����x�մ�Vx,$��������������
����������!��_���S����������������PmuCkon�����0ns��������♝\�}���j��|� ��Y}$T�����N�����l�m�e[�öx�Zי+�[���3W��ҕ+v�ryma,���fߗ���y��pV*��2
��؋���z�\
G��dQ�{�����z��Ǿ1=��:�p��-⁻�����r����Z��K�N�-�w,���Ɨ�����|�e��e�g���X޲��=����%6�kc�����5-^n�Bp�<�xIi�Xu���Ͷ�}S�U{���Jc��������pS�]u�h��`0b֪�ȪԐ�5�pd�aM�;ő0���Z�p��}j[U�?�}�_F�~o�o���Y���
�Q��c�"�?�����H-
���2�g����O����O����V��s8�?��+���~Ș���`(D�������L �o���o�����ޢ������]~Y|�>�'1���A!�����ό��ߤ�C�P �����w�a�7����`�� ��ϟ�	�&���y�?�B������������
�������?���l���L ��� ���B�?���/�d�<�����[���+7�������P�
���?$��� ��������A�e���"@���������� ��9�����C��0��	����������� �?� O�:�����[����;����	������
�C�n��������E!�F��ON�S���Sm��� ��c�"����a���P��i�L�2KJ�k$��Kͬ���ҬT)�`����n�ZMM�P���0�Bc4�>|����"�����!�?���{y��E��0���R���͵%�m���-����Xhp���@�o���5�s��յӈ�#�ءU��7	���	�k�+:`�6o�t�z���n� N�|\&��n\х��$>Y#�X*$v@遪p������%
�{���*3����U�͓��jk��+��x���n����?�懼��h��E@����C���C�����$̻E��������8�j�^�):�0$f�带�4�X�f��}$���|x����d�]v������v��D��g#���=�G89l*U��3�FEGwMs�TTN�V�HZ/w+e�Kb-��C�\��}-���W`�7'���������7B!��+7@��A����远�@�B�?����_���߳��~�ݎ�Z[u`�'�$pC�����8�����%�9�[H�����t ��|�y=��b2˵��i��0�;\D���n��6Yv5oVf�q��gf<-�3�ȹ��k�$�
3�����koԥ_Q��^�ǠG	͕V�vm����K��U�ȶ�.���p,\�&+�,A��z��L!�s\�H��:��G�"9ND_�\���:�X_��^K>���'�������qv���}I��F�T����u�s6n��q^�����q�&����a�:&��Ԥ����.aj�qT�A��|�Q��S���޺�9 �=
�,��/��a7�&������G!���S�� �g������k�?���?���O`7��b(��,�+��E`y7����?w�������O&ȝ�_-�w[<"����s��N���f�"�?�@f������?&�O@�G �G����E!�~g��_&�]��
��������X�!7��a��\P������Š�#|������?�z�B��q�SG`3zi�7��(��=�/�1�\��V �V��~��H?�+�i�����67���v�u������~�'6��̞�i�\�{���#5�GN�e��;]��y��Xo�4m�fyW3�З�� ٰjN�3WT,G��IZ��|k����S��j��u8�vlJe~Rf�H��;V����\n�)+��g��ܯ�e��qZ�f�����Npld�r=�����(��z�H39k[�n|,��M�9ϰɍQ^��T^)$����N2c�g�����sC����"�y��#���������E���0
�)
�����`�?���������0��r�ϻ)�?��+�S�N(��9 ����!�?7|)������W���n�m6�9�T�(kԞ��������q,Y���Awݝ��e
T�����zwb�p
Ȟ�T	�Y�몎��VQ�;l��C�+���E�谭���6v�2�QB��
ww�P_�d�5�� I� �J ��Q� f�+[��l����2{�G��mH�� �3	��-����9`5����܎4+����=�ro��v�F�e͜��N����3
���;뿀�W&�]�}X<�xL@������_���?V���@q������VӤU]�UUcY�4¤0�&5�"L���5��uS�4)��ڨUbI��÷����(��[������\�s�,��CzU�5_���H�y�wT|5��b�U̵ḥZ����|���y�ʺ�B[��{k�� Қ�c۷*��9�
}�:Dyu���9J�y9m��x&�f��I |�a�~4��?�E����3?�����@�� �"����B�?������e�$̻)E����������~3�W�֓]bH]��t�u�a���?G}.v�����C�D�ƣ��~�l���A�o5��G��0�fXe�hb�.OＯ�_1��������ن�ɍ7�9;z$��ע��M���?�������
 �B�A�Wn��/����/�����y����E�U�������������e�>=�=%��j�w�w�����/5 �S�}[ r]�u@ym�{u#��NU�e�a��b�agx��UM_ۢ1�u�D>Ր5Z�W�*�hz8F�[�*���<Sj�����5����u�͊���Oe��<Ne�F�E�q��*7�9���6N�C��E.n�� �
�'��G�qӯV%/kJU�y=b]s[��KSҾ�a1�\�<���*��(�Ѭ3e�;ԧBz.7>�[}ԋ�gƁ�G�&���@i_�yf"�=�[�
1fOkq�#s�V��j!$O�u�ע�M��AhN�֚���_��� ��k��N0�i���q����f������cd��>���+��t�ᕒF�FF��K���ӧ���IuF=�� *�,7����(�ﱣ�/?��u�r\tLO�����1J��/�{�
R�1���m������V_��>���Y��OZ����۪�����H.�e������ec�-]_���u�˖b>�o��}�ӧ$��<�����/������O�i�<�o���9���� �(	G'*m���aT2�`�������&}b\�[�OHhD�w�!}��Z)����#9r��m�R�����J�������T�H^�ʱ���aw<�����﷟J��S��,��2y��y~˯�	~���s� ˄������μ=������)-��������w��>c5is�'�6��2���(E�����x���~k^�/,�vB^����*m�
>��KN�ҧ�:���������/��Q�������� �noK?�z��ߐpc���M��B�����.��\���|���m`������K��ﶥ;1�1�%$�9��͍������=�N/V�:��]R��n�铻x�����@x�������w;�,=wT7�!�Ô�.�~�I�?}Uì��}�}~�/]Y��~zB����   @������ � 