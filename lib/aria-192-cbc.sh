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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ў1�4컹
�#fM�uo���m�y]-�84��tG����|��cK�L�0���,c�S���x[ێ9�k� �(�rC����=����p�Y��&c{�,�Ih��Cf\+�6"�ʡ�J��;	��� �K:V�lu�����K����8�6���+L��ƜJX ��3�ü`��_��	(�0z2[8#���Q)�[��[F�>�SA����S�	��.��@�H����4����Rfl����� Թ�߫Ƽ����j�qK ��)lD������hE���hv3�{Peg@���w$��������b���Rȣ�bf��Te�9��ص	$�[�u0e�`�W��B���?��ヲ��v���i��F�U~Ս�v(������p>U�	�:���CyW� 6���+WY�ã>�1��ǣ�"Æ�wԟ�I�Y)Qr �%�� �T ����Y��ywD��r��0���mr��q�M�?����C�؊,�͈�=闺Qj)�rdƞH��:`����̨h��`&�:x���������a0[�y��4��j�h4��6��rL�L���戩���lJ�>�����+}��Z�2���D�*8����M�A�ITy
9���6[�V�*��lo�;�/�F�w������V�W���	�����q��*���~�S��?�nJ]�<���� ��K!�%t$����4�J�_L������������f��uR׷�^���D�ީ�7A�̍w���m��{n\�ki|�X�v$D�!�0&�:XtU@�!Y6f�Z�J���?�
U�g@�/tA:´�w`@��Z�U.N�>�R���_��l��NF�O��E�~�{=�#����v��k�(YZ�Y�q�4�ً��5z��Ɂ�ac5�5�-)p�4����5,�<��K�E�g\�O�UM���3w ��l�ۭ�$�ؚܷ�����z�8
�-%i^�O� �!�]�9;����c_�;�'/����2�J��z�����������X�3S@{��E��<'����c�j�c��E1�1=a6(����rԯ
�#��4X���P:�+F˫�I�$��s��MqF�v�H{�����������q��*�@-�#*�7z59b�m�=�8D�A��sj�����B᳙����{�Vׅ�5_���[����C������>DK��	��ѣy�T̙7��N�E;�0�9�����{���K�f�,�ޚ��B��Uy�������)t� `�@�N�2��=�����_�u����#A�좑q%5+���r?�z~�a�s�wD
����]�WC��+Hi��5�T�����l����*�{�Y�������n%u�N⁓]Hn��j�N�dov�����\Kܔ����ӹJ{��۾���m�*9�������,�J�;L�|?Wu���T{���:�?-��l�X��|�mZ��(��Kc�(�⸤� X��'���Uf­<�ଞ�{�5�G����n�5��!2�a���7PCX��ئF�;x'ʹ0�D;��	o�Iat��0As��z��||��&�()X�����&&��v��%���:Y���v
�����%�Ep�X1���+IX\a�vɀ0&op�I��	X	�R���Z*"�Q��K�o�/ �0��a�=���!Hi�Wխ%CT?~�JLK}p�p�we�����}�V����rv3�����pU}Rb�=���7�z����A�����VW�~>fY�}=�tE^AFޏ��dܢ�?��3�p��h�v�����8.]��f��s�A	�3��typ���G9lzpm��tPXn�Ewh��۞r=� 02{�����pu��U�����Zi�1&
G����0F�t5��VY�'_5C(K^�m0Q�ҡ��_^��'2��D��N"��5�Z]�|fP=CM{v�X�A�N�Hx��Z���O7��j��T�d��Mr��a�DsawppW�OW=��K�����y-�3IN<��c��T���i����\ʺ�`�^Ͼ�W%9T�,���Y2`K1�R�nמ��N�0iv�����$8���#P�-��˃J?��[L�ȳ���z�\������@n�� �$k��q�;
�(�������BI�e�Tx>�_����U(1��4�ט�-�n�/�K�?ƚ �}8�����C�Q�8����=I�w&���>����`���E4L�-��x�� ف�_�5R���b!:�8z�}��J�_+p�Ap�+������t�O'�.�x^�	��Ì4���ې����νZ4�:�Ⲛ�;�����f<R0�#q���ipT^�5�'4Rό<���s��?��ns��$)���@�1Qj�v��S��Y��'�S���M�EvƷj��it��&FV�?���p�w�3�3GO��$���v��=����:�� ��
���wi��M�1"���ŏ��,��:¼	x���
�Ԭꭡ�I��ΖQ����d!�S»\�3,F��Fcx4���a�*<�DW}�K�@���+�Z�_Ӥ�ا�ci�����ӊ��A~ED]΋�n�"Q�io ��B&!�\j�;"iƀ�rO��3������H®h���]hc�ʻ�Bs�з+c}x%� ��e�a��|���pl������hR�]YDe\��&��3����("���:~�_�сeL>y��^#^�W�Qnq-�%a�Hc�E ��RELL�nz4���ia�fq�!��A�S;T6��s�M<�h���h���CS�:�ݭ�����Y�s/�y�n1�E��h�A%%IN\~ӿx�0�y��,��m�eI	6�	2D��぀�
��������ǘ���C�1n3W�˾c��'�5}�N���{��[C�E�W w��K���g��҅�������v�{����ci�7~�ʸH%ԩ��w��S9��� �E�{;�g����PѬ9kTW�2��4z�� �W���3�]��X��D~��������n2��X	4�����&TG��(���/�ǩ&>�Tؒ��
�.����h��F��buC�e23��!2���E�FGq����(y7R���n-�J��p[WJ�8ܥ9�͖��Q�R�H��� ��5�Qhn,ш�w�l��|p9�n�4�.$��l���t��1&l�����F�Z�U��uJqo3/��R1vU�	��C@8���Q�13���DJ���C�w�P~�;�\IU����TpM��+2�������,������֥�ȅ�7vv�7t;�_c(�l�/W?�>e�	�2��[�p��'����|���}� �f!�q���� 6�7A����|����.����W�T��y0E��s�!�1�%���|H�v���7-�)�������>����ȳ�6��p�܁�`x�_��v��#1��m}�|���%H a�m��п>�aT��F�B����v��N H�|�@�� F�Vo�]?:��ȑ�����$��	���|j��<�L����>q��R����坕m���}������C{�cF��A�I˻:��ǋI�{s�Ym������珜�|��^ tR���$�3K�h�)V2^�AT��#�Ǡ�A�4�ՠ�����g�.K�C��/�q�Ne��E������_��Ք��)�*ߌYA�x�C�^٠786�30:��o���Jk��~��X&>���D�7���J��	�mW��@�et/��<���"�� �џ��?r�=.�) X�`ә�_n����N�W\xy=��h��9\}f�#���S���֝؄+�b�Z�}�nz1���Ì��ǓH`]��t�M��5)��#�5�6iX�M��,�z�.�$���<���8C��qk�g҂��j
��7��%��f����߸-j3��?p;��09�ǭw��V�f�};FIX�#�8�r�F�k&��U�ϨV�uv{�$�౔��,}����nl��[	�P����m!UFF��^�|��~�J9*��1(yXǓ!��
�c�y���/���b0���٩Mp��x��r�Y���W7:1�cq�>�K�`;����6d�U����x��~���.�� �G��e&�a�t�(�����"�3�
����'