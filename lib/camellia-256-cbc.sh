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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ў]��
�#fM�uo���m�y]-�84��tG���T�nPa8X�d�c��c?�Sb������u���r���"��Ϧh#G�L�%����s?�]����6��-		�g|���C��~3����&�7��u|�b6j��vN�x�Bz)\
�i֍�DL�[��b���V��*�T|�Vβ��8�i�J�Nc�i�s���a���(I
��9V�ht��#]�!���篴�߹����L3�f��c|~u)~QL,��zy��]"GO��k�E �ԕ��Fd�����2,���83]�Wirq���M;W�Jm�)�!PRqaY�U~_�b�V���t���j8���p���(5=i�zeW�(HYw���L:W)ܚ�Xm�(s:�����ϋ�%l<�N�eg���iӥǓ�CT��a��?���B���fA]�>�{�NY���7�u?�BO�Z;⪒Gs�יk��E,n��a|���"ʅӼ C���~�E\�U֩�0������1��T�Z}��/����¼X��?�Gˇ��/q�'SS��y���.�!5��E���ɡ�����A{������2r�O�UWT����\�s���������O����}���Cv{��C�D�& �cx"jI��Y䄛��I#C���U��-�w�Ţ���BE���Hpɘ�7<`���I���<Z=.s�kHI����������"#S/4fי}��g*.E8�ʚ�I���N�]4"c��S�6�1��5���F�?�Q	੃�?\�F���-|F��gD2�6�ӌ���y��(���ą�	���T�L�QFv��Yg�;P3 Ԧ�T7V1�c^sBr��d0�����a�c����uM��%]�~~��0��i�P����F�tR-ιS����V�����H��zK�d}���v�g��e0��.Բ��#zz�;���Ns$��+�$�����H3�9��\���!dx|�q_�iO�j�iUw�����KW�38�]����~rL������fPvj-;>���J�L�9��L7��r�/awʫ(԰iTB�t����z!z�q�ls�a��,Wp��w�\'�>~!��!zRI,K[�Emg��z��d&L���h��GA���#ޏ�|�/�����3s�ap=k��T�����8T�}/+��>F~c��Km����47PR�h,ڪ�m���!���N1�݅�w,6����=Y�pOW^o�7���VU`�d�q�!����5W�Qq�%�=�3Ŋ�zS��2^���!d�Չd�0�]ϡ�@g���c^V呂�Wu�ctA��!�ƸQr���d���\���Ç�p5G鐈��M�LE��Z�W���=�%�Ŗ�k�Lh���R�<���؝-�ۮl˄�#�d�G�؃�T�|wp��F�IbI&��o?����Kt(>�/���.��¢��������ա��4��O��T��+r2-6������Ҹ���S�"���TL���|H�Yv���j��k��/ӭ<�l�\�\�=Oޚ�<Wb���[g������"��$�p����t��ְK٢n��w6���e��J�:�~�7����.eI��}ŷ���=)^X^x2�TL6��u2|ٔ
A�,)U�a�X|�=�K�j*"' _�=6�[%*]G���I�M�&�h�J���=E��j���!<sd~)zAn��~>Y�z�Sk�]�ێ�پ_B�̻1qԄ�J��l��;�U�8��T�"�#=�z��R"��D/���h�^�B��<�B��E�=�� tC�����0h�O���pZ��
�au@�]L��\����I�WJ���A�aj1�-��Za��~�0S�a�X��BX����I7��mZ��ڃ"L�Y��A����������g�o/��/��ڦ׍�й�a@�����DU8��x����۝�ԣY�u�<�/��h�vt�vJ��B��"����|�US��)�����s,���+�M
���&�Ee'~t�J#~0c�U��ƹïp��\{�N����j3�ߵ����l�?b�ѱ���;o���A&D�VK�z&��-(�~�?�������+�P�n�����w;�v� �j,��&@M�-�T��@��M]�Ŷ6|�^�U����gRN/�V*ӧy YN��\G�0�`Z�$gv)��؅6����T���c�/U�t���B�<���YO�����l�?q&ne	5�����Y6��Y(��>_�M,x8��Q*W]a-��;e��[!���b��!�3H#Y�D
޻-p����W��;Kǅ��n5��bqR�W�/Q��(��@�g�[��v����(��bk:Nޔ��h8*87J�/����O,��f�>s`ާ�T�*�-ģ{0�rW��HS���I�
� ��Dz�0�%�!G5ڏ˧Xn�<5:�̬d�xN2Ճ��]Pi~��'��ڹ��n��*q\;q��ʲYӹ�iK+�e`�i���Eq���n�gH�]WL�a��$��F�z�'�|� ��m�L1¿5�Iat��7&j��5w<��v��8���K�^ǹ�i��o�� �x�E'���D/[]xz��X��	U���+�WK��UU������֨�LC\&N��kҷȲ�.��1Z{�tJJF=M D�����C!����Xic�j��|g"����Ͱ�EǙ��|����hl9{�0�q�)�3���;��*f�^�dA�,�
֬p�'iA�=K��n����M��"�G�X�]�8U|�Z[e�*� �ٻأxNsmXW�%QY�Hk`��׳����8��ŏ��-�װ������t�F� Z�#�����A����4�����ϯ�|by���Ry��w�~ĳ���>:��:ٜq�����9�CЩLn�|	t<J�ab�)�)ҹ�w�"0���Db�����P�#ܱ�B)iC$���l6g���l�Z/�Q6�e�ܟa*��:|�#�{?������/=��-ҍ!g\�2& RCX PQ|s�n�$�5��i@=m�����@0��Ll��O���� y��h��	���1�b�ʔgO���Ə'ME9*�-�$Q���3��&�R��}=h����Ck�a�,c�]��)�*t��d��Y��E~�6p�hEn��Ɔ8�����}A�&ePA��mм�}e.���B>�c����O�M�C�e2q۰>{�`�9�6����v��&����GUA�{�G���h\��!���dПZ�r󍢅=f�P��7�塦�v�E~|ׯ*N��v��eݿS�O�| DϞ������y���`q"@U��>v�g����A�lP �V^��3I����2oL��
�٫-3?p���%	�DH��q��#v�$����fI�M�s���F~${Ț��@�Y�E1���w�Ez��E�泲���	gbt�S%�O�|4&r���ci�)#�q�B�J����T�\��Y�Փ�:J��~%������5d��Se5}���m;�Uo�ڒcvWf#p]�J.(;UyM�EI*���W@X�����gϰՍ���ݬ�~�j8,D-�lZ2�g\�b_���:`S�c�,���3��Z�J�I�'.B�^�$��30�
|ee�2��$���:�i�T!�L�.�Xq}�<����'f�5�5V։�;�P� %d� ������P-��յ -������-�����.�%�<�	���m�I����HQ�J�F�BOW��N���Y�4. ������3Zk#5��ф}͘�+�~���y���|L�$�f���-�@[���FP�נI��T��a��H �$��r�� �A��ht�K{Iz��V��V��{�,{�� �a��Ň�pT{�-�hCP�8���a��Q��c*)v���☡0�����B��H��r��ܬ�s7!;q��F�QS�4Xn5J��ۂ�)���ZP�x�_���&����,k�[B^�G��D$��O�%���sn�/�Mi٠����@�6�,���ڒ��F�w��2���K����a���u�[8	!!8��r���s�5{kʤ�w~�W����D+�#�4��i��9F�t e���_#�>6�_f�E�]��p#\����m�qb��%b�f�G�u{t 