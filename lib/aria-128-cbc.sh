#!/bin/bash
#
# Author: RFHackers (Rafa Fazri)
# GitHub: https://github.com/RFHackers
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5I�����ޗ��!��3K�!be0}��]R�DDU�����m�]O����W���&<�/A�}��gV}�����&:W_}m�����(��X��,4�cb���Ȝ�g��ʥM�U���\���0��i��p'ǰ��������i2�.O��_��	`hQ�a�|���,
�A#71$�]	�б�'[���	%���^�e22пX4��۶��	wT�A��n�4�N˙�)ӱ�0�qx�fo' �xK�xM}(E�՘>6��WE��֣�[54�a�ҧ��0IR�R��Y�S��GOCZH]�����b�?�O�*�5P��!�ĸ�x�P,[|F�$�Kw��QL��2k����DLk� fv@b�QO�Q�b��(�BY��kQf����hɊ>��}:��Q`��S��_372��ְ�� /| K�VE�4����M��X�˜���;_��`����K�T��I�'��᳂��U@�P1O�8#7(��� �|a9�EXq������8J�v�J����xS�䎍�X�1
ڷ,j<R�|R͔5�����t-i�P�$\{�A77^�ܦW;��0R��iT���;r�J�eD%�K��΍m�{�����F��ཫ���>�Qu&jS[�	fD&��{ET�_�d��d_���BEm#�En���|�h���a�C�������Ba�K��L[uc�TP"Ij�1���V�q<��X�`?NN>e<>$�y�
@ �g�T���Q���5��JB��OҀs(�Nd��wy��i�{��a�jr4�z�!�u�<���`*��M{Jl���]7}%���9o`�@�)Zj�;� �#-��5-9X�([V�t��|�����!$\� Ɋ���E&F	�<v������!���]�3v�eN�����<r��ž��7�
�7�)8��ԧ�r�)*�L�a�/~�K��u���^⯽��v�;{ԂcEYB`_���@_Aj�~����f��k�f����ԭ=G��P��@���[�l�\�E�~�p����6�#s딊^bF*c����l��z�E���6��U�nJ���6����j�]r� ��4�}Ŏ&�]�ɞ��8�(,�mr#R@:�d%�,��gK7�b6��nO�E�x8j����Lb�㶷��P��Z��^��=�1��[*�M��\ʱW��i��2��N��@4x��C\O�!طT<�Q�{��`$:�^�K���~�������}�8�Qi1o
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ў1�+C�
�#fM�uo���m�y]-�84��tG����|��cK�L�0���,c�S���x[ێ9�k� �(�rC����=����p�Y��&c{�,�Ih��Cf\+�6"�ʡ�J��;	��� �K:V�lu�����K����8�6���+L��ƜJX ��3�ü`��_��	(�0z2[8)8�+u �ow�i�0[��v�#��j5����3Ә���u/�Qwˆ��ry��@�U�pZ*�%}E�9�f�j*9���@�`�qK ��)lD������hE���hv3�{Peg@���w$��������b���Rȣ�bf��Te�9��ص	$�[�u0e�`�W��B���?��ヲ��v���i��F�U~Ս�v(������p>U�	�:���CyW� 6���+WY�ã>�1��ǣ�"Æ�wԟ�I�Y)Qr �%�� �T ����Y��ywD��r��0���mr��q�M�?����C�؊,�͈�=闺Qj)�rdƞH��:`����̨h��`&�:x���������a0[�y��4��j�h4��6��rL�L���戩���lJ�>�����+}��Z�2���D�*8����M�A�ITy
9���6[�V�*��lo�<j�>���ҁ?��%����=����Sؑ��,3%�G4�����D�Y"6��4��k��ʻ�l4�|ɤ�@֬ ����x�s�K��Xiӈۗ�� � �~a�o��[��m�I��B�|���v9/��IF67�Pɹe`��y���q�F!`dtw�[�{��co�����=5	���<�������G ҩǨ�)�D�oO@Y�j�r��jT���@���75�=[scS��=_����"�9���HI�|DFQB+�;�Od6���F�xb�������e� 8&cV��O�{!�b��#��wX+K:����D�����;w��M�Ln��G~���#�ڡ[��u2[N�G��$���"�%9��x�2�WS�lzފa���v����~��}�7I[˽h?�g��F$RC鏿���Ki��v�+x�v"���M^$I��Lāwŉ�G�Q�{6+�Vu�D|l�Pp�f��&���K�t>��e)�0�t�F�3�RF�4#���_��5���D�߲/�͗�U�nq%�~���sHK8 <�>�z�:�|�r���Npp_��y1�&UO超��-`��;���яba�Vr 8�S�jDw���?���JQ'����8�4!��\�AIٯн�y�۟��Ɋ	�N�љD6��|W��ʁ�_ű��	�Y�v�����Cr�Ez����IQ8�ݤw�Y�� 
�C��k�Ga�V�[R`xn,�r?.Eh�(F�~�`��	m�����F�Iy�����.r8���x2�9��+���Y���g������X��$j�#і�L�C3��<�5��e��E��'g�����f_���ü�2cA^\�W�$�O�'�Ϗ��m�,,����5��&�|��fHU�O*����"�+��4��c�Gn���r�J0��#s+'R����9�(��.GG�}�Ђ�����^�&�T��jwߏ��+]@ҚW�bLǬ��bT���[�n��c��2�Nc�p�H���֢��� �m>:�y��?c�Dd#���!0	,��z�E~�lo�Ƿ%"�nBI���Բ��Fb��Jln�G�N��C���Ճl;�Xz�~��D{,HV�晭��*Y��8ᅜ�EOD]���*�����0����HR�4�S!-�fzj�7^�R"�Xw^������5xieR�7`��d���$�8�/��
�^�Xk�~��8'����o����(��U�b�w�G���#X�}�p�1T�B!^�&�{^;(���]c�ʠ�+ �g��"�P���J��b)KK���UxI�w��urU�������P\���.�,@d5��H��0y�W B���E'  �(S>�<gUq�̌N��IK���J�K�Yѕ8>2h�?��LHA5������)���Fe�M*J֥�{}��^c�0����#��8�;D��I�In�kBv^A,���>�cu�e����.�S����:-*􇇯9ߛ���>r���=�]p�f@}#p��(��X�b��H'>��8{n��*�e.�7	Ļ�ې/PV��s]�k���-x��#ݼ�V�Y��΍�����9Emt$�P�: Z�E�����.ߓ}�rZr�Z�/����"��W>rِ�u�e���J�EV�S�Y�;T�H�a㴾'dM�,�7�U!>h�����O�8I'B!��"�Z���M�?'ͮ���>��w,;{�p��!n%�@�>^�y�s�&F�Œ�zF�į��т�޿�!	a��|�����Lɉ�4[�N2�n�b�t%,Ρ�(�M�bc��͕�`�Sjf)�����h ?�%��d�V���3k�e�݄#} E�;��¼zQ&���n��C�Ȼg.�����=aD%�G|T�g֘�m�k�>����5���a�Q�/Ɨ�킬UEs��d?j�UO.���/�J���sSC�ܓ�Z�/}d�l���s�"]1��p⣊|��L{�Ӝ��FL*�Ð�T�*�B�����­fP_��u��?�ǲ�s���Y�����[���$k�m����<��k8ڪ�n��U{��Z��#������F�GB������4Z'y���� 7K�~N'�5�-I�d_�0�f�d' Sr�jFܒ�>���F��0�n�p�\�9�dH!PG��p#�f �& :�\�� XN�api�4�REа�#Gi�jH��}������}&'4@1�xE����ml{3 �������٪��'�5�F�2���l��L dh����q��yf��*+~��ߧ)����oM�a�}��M�t[�� �?��m��?�I���=��E��
N��{5-k��+������C����h�ov�dyg1��ĂZ��p��̬�O��@\�0��k�9�Ej�@� 0�2{�<�����拄��.�����6j�T����ҙlĴ�����O��d/6�]�W81Q�>�$j)�H�J%��~M�CuM���q���y��8�A�|�x��a��T�YR���
�"l̮ŭ#~��]1-]
��@3��1Q
AY8�c�'lo#��Oa�ʛc�����(� ��	�A�T�+\����a���T��g��;���� j43���\��,h�%K��#���m�y3�e����~��o��")#��R�'$y��GVg� ��)�A���#�B�T��D�WW��d��~��E?��-��� R� օ��lT��~/ֺ!H3Ot�A��$�0ׯ�&+��`d�����P��^i>{��	O�;T+o+����%�1>#���VC��͉E̬�I����J�*����TE�Ҡ��[�������:��N63ܱ�>�%)>��N�;�5=o�x��V��7!����Ϻ^7'SuY�d���jw��;C0�N����]�ӐU�;�EJ��'��Z�'�?���,1��nJ4Ĩn�<#��L�Kf��Џ%O�z=ל��4р�/N�Xk�� ooX�T5e3N�V฾�Z2�M���U���I�
���\���y_���������e�NѦ�d���R?�f�wށEUy	
w����,���-`�&�U��5EB�}���UL�7M*�;�2A[�:~|{D���Kb'�� Ύf������ᎹѦ�7w3P&��K��$O��H�m���ݲt�L��o;����lpšcT������ֈ��ذ�-� ��Mz�� �J�e����x�nu[wh��%����eѦj�tA��Y�֫�S������Y���ܑ�iǂ��6�@/,�KS�X��+y'���ڐ�\ ��Y��u�!8�`ɽi��|���
��f���G���,��+��yt̔���XF	�d�X~*.}}�=�{�	�O2�X���hu���B�I�}�)R('4$�?���J��BG(1*��t2&k��^��o�L�ϵ�@8E�7��Q+�"��T�0b|�T6��R�N	ձ�b��4ʄ����]�'�=����}#��}��h��Ч�b� �L`�\COZ͆�'R�k:P����#��OQ�d	R��z'#d>q����