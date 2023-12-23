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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Љ#2s�k�}�?��1Z~@�<�r�}�L�2,5w�̎Ίǆ^�3}����1m�~�?�:�z�)8�����}|�4�w�}E�ZC����7ɚ�������W�X
o#~�҂5�W�C�:���ޛ��ANeI`���{*����Ot|��x{|8��=�][+��L�8�/Ϳ��kO��RWH��s��0������ �~{o�H��1.�[�5�;�1Nұ�!�%8Iw;�A;� �(j���uH�[�Y�JO������a�����]=Z��z�6������^�_='�C��ྫྷ�BI{���e�O�[-L`U/�B@pɧj�$jl\-��Gi�An?���]�Mޮ�����4����E���%X�y"46�}@�J��巼����y���w>2\%ُ���<\Kh�m��a�zA]>���Y�n�!YR,�J�@��q-ӹ&!q	�����;�[6ܟ���i�Ϭ<j ��O�%�]*�D������Zo���kϩ.�1x�Y����|� Es�V u��)���ҭ��t�!|�=y�!Z-@�a$�NRR��
Y8�xo�=�O�\��?X|�����f=�Cfw?͇��^7��4#�E	ao~� ����=ZF{Dɺ_�k2��/n��A���q.�{����0�V*���eۇ�*�y��ޛ�����kQ<�3��dȠ�HYw�٧���m�)����hk�wj���l>|?����T��qQ��V/x6�Pe��.���v����O�.��P_f�{�ě��e�Z�y�*x
%��,>1b�范���]�f_l�g�$�O�~�(Z`Q�6�UO62�Xث93����o�H� v+�}��١{^⺒�3 ��� y�ߝ6+���0�V=�����OW�[��%��t ���^�a͆�1"�r'���|�x{,�?�T
p9�l��pGdh�x�E�����&V���7��w���3���QPIp/�/x�;�+�?M��,q��!���(�RVp���׳bl�#���;:�5�k_�X���S�i�%m�W�u^削]U���Q0�6��ؚ�ǭ�zq�n�S���ū-�6��o�C��AR����^)pW������)Ӡ�x��y_O@���Hcn�#������#���d������x�W�rS��K��&��V�� +(�H�t��/_���6O�]�oǙ#鍼�]���9|�,��U����*E�d_���+�*?�C�'x�,2��՜����������v�ie�%3I�(�O����	���j59�H.����5�辧^�8*��f���F0�~�֠�PKi.��pê�X��C�4��ϋʀW`��M�Y��� İ֪������n38�s�0؏����� �L��}��Q����ea�����9��Y�K�&&�¾��6r�O�y�?���h�`�$B�W�(}Pэ�V
�LA]�$�������Z��ۀ��{~��n�	MAk���	��ܫ$<������B�|;��*�Q��#��l�DҺ��V
�oG�n11�r������h���+�D�xL��T�f�;�R�/�ӟ9���V���)�]z"�y�QNƢ?
�ˋ��P���eZ�-��d���^���"�Úms�]���a\Gg)��;8�[�X,O��,`+�ʦ��m{�ӥ�!7�r�J�4��Є��{-�`a�דx���
ɖ�mډ6;�fS��{���:=D3�ʺ��jW�f��jط�j��w�a_F��'b�>�J~R���Ac����T���y��~�j�Ё����^��pv�"���k�k���	���ID24�t��<3˴"פ0y����z������g�>u��J��� ���C1��0��U�q�`a��wT}�<�z��*��P�tS�J4�FWS�����`� ��w�R�A���I��<?��Q�f椝��ǧ�jNɁQ�3�ˠ�"~т����x�B�%j�ₜd��N�Qt*lћ������3��*Л��a>���W���S)��e�Ω�!��gir�oJ��)�8��i��!�z� ����RЂ�A#t�T�}Ơ(�=���w���zK�Mk��<f��[}i��yҕ�X&F9�Ĩ�/Gw
�6���	��#���j�N���u�@~�9Z�F��]���5ˡ�V���O���X/Tx� 0ŧ�:�Y���!���Yu_�<�Hf4ɩG,]���tB��yͫ�T4t5^�wJg��խ���̊���a���޾�>k�-1�a|�@��3��у���*�Dk�����_g�~�5�ѼԆ�/�����D��!V�G�ޅ_�闍�H���6r��%��Pxb&�WZ]�ȓ�*��>�'�=��n�	i�E��pr���;���GԨ�*"�K��~/T)����4x����k)\����C����
�p��p�D������pv�E��K�Ie5��g���v�&�7M���H�.�Y"W{A	������E���p|���VY`���@䧨�?	} ��������e����(PB�6=�j[��o��`N��E3��,K-e�&4(���tc����IC��#~��-����놨��B`�һ?s(SP��s����
|�v��s��K���3�H-���F�V����u�3�׆E�/P��R*�����	�<�V�8����:���F�I9�����3����Y�xy�G�$8˳E��D���v�$�0��JM����y�Ry�z��(�&[@��uv�ni��a�Q�b�8��D�����g���-u'4Qkz^� ����{G�%8<K�w6��'��j��W%sT-P�� < �P]i�����C=���7��^"B����"���a�C/�����iO.�4��AKז\�n�l;9]�8�N�h�.KnRO wN�\U�~���T����� �j��}�/p�Ƃ#��޻�Al,�c�nǃ,Ө�_���8����A5��涠zj���j��#;�%ª7b%�s��t����+̀�s�0��TbN��|��EK�M��h%E��|m�G���:=X.S�q�VOҪOӻI��8�(2��>����H��i��DiѦ���zJ��8mǧ-�+�o6������<A+��9��A9a�9�G͋+c��o9
��۠g v�HìR�洷I����m��p-r;|>�RJ?�I~�]œ���=�&��F�nI��0씀>O�-Ӹ��S�<��9��-)�s�Q��|����y����*�F/��7V��*�������'�8J��e�z!
��=,]U.6�އQ�d���r��-��Z`�0�/��E�:qVԔ��C�_��qc�PB����4s���zJ���]��AX:�l��n�Mg[ ���^dڊ��������l;#�.�m��q;sF-F⭯�(����tҢPe�'dQ	�:��Ƒb������;Q�G���\��b���59��ki�)�I!UC~A �IB0li�u������l��|j�A9|'�;����2s7C�;ȋ_�]������D`c=U�hk����΢�KD}NJs�������!��?ڟ���q�DQ���9{(�tzd�_4�I��蠯F�:������sUØ�U�'V�vk�/�d���ٷ���|R�J`P��L�\�y-������5��E�^�=6vJ��Z��lN���O�J�Afp��.���6;�>�{�*��A=�u�uS��HM:m��a��Y�:�X�xv��+�(z�(���Ԯ�S����;��!P{n�x7>�d�!e�[�1c},,�X1$�,'��9f;뻩�zK�'Х���|�o��x��ds/@W����E��I�i�{���Z�?�'�D�CU�����W}�=)�q˭�ƫ)����.Kb,�l�h�<�p��/���BDg�����(����/m�3� �ޙ����� r��]2��ׯ⦘��'A����g�FR�/~K�$���X��O�C���B��1�q�4yf�,L�<�[��eD���U 